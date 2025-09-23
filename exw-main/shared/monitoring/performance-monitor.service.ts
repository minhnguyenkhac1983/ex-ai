import { Injectable, Logger } from '@nestjs/common';
import { Redis } from 'ioredis';
import * as os from 'os';
import * as process from 'process';

@Injectable()
export class PerformanceMonitorService {
  private readonly logger = new Logger(PerformanceMonitorService.name);
  private redis: Redis;
  private metrics: Map<string, any> = new Map();

  constructor() {
    this.redis = new Redis({
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT) || 6379,
    });
  }

  // System metrics
  async getSystemMetrics(): Promise<{
    cpu: {
      usage: number;
      loadAverage: number[];
      cores: number;
    };
    memory: {
      total: number;
      free: number;
      used: number;
      usage: number;
    };
    disk: {
      total: number;
      free: number;
      used: number;
      usage: number;
    };
    network: {
      interfaces: any[];
    };
  }> {
    const cpuUsage = await this.getCPUUsage();
    const memoryInfo = this.getMemoryInfo();
    const diskInfo = await this.getDiskInfo();
    const networkInfo = this.getNetworkInfo();

    return {
      cpu: {
        usage: cpuUsage,
        loadAverage: os.loadavg(),
        cores: os.cpus().length,
      },
      memory: memoryInfo,
      disk: diskInfo,
      network: networkInfo,
    };
  }

  // Application metrics
  async getApplicationMetrics(): Promise<{
    uptime: number;
    memoryUsage: NodeJS.MemoryUsage;
    eventLoopLag: number;
    activeHandles: number;
    activeRequests: number;
    heapUsed: number;
    heapTotal: number;
    external: number;
    rss: number;
  }> {
    const memoryUsage = process.memoryUsage();
    const eventLoopLag = await this.getEventLoopLag();

    return {
      uptime: process.uptime(),
      memoryUsage,
      eventLoopLag,
      activeHandles: (process as any)._getActiveHandles().length,
      activeRequests: (process as any)._getActiveRequests().length,
      heapUsed: memoryUsage.heapUsed,
      heapTotal: memoryUsage.heapTotal,
      external: memoryUsage.external,
      rss: memoryUsage.rss,
    };
  }

  // Database metrics
  async getDatabaseMetrics(): Promise<{
    connections: {
      active: number;
      idle: number;
      total: number;
    };
    queries: {
      total: number;
      slow: number;
      averageTime: number;
    };
    locks: {
      total: number;
      waiting: number;
    };
    cache: {
      hitRate: number;
      size: number;
    };
  }> {
    // This would integrate with your database monitoring
    return {
      connections: {
        active: 0,
        idle: 0,
        total: 0,
      },
      queries: {
        total: 0,
        slow: 0,
        averageTime: 0,
      },
      locks: {
        total: 0,
        waiting: 0,
      },
      cache: {
        hitRate: 0,
        size: 0,
      },
    };
  }

  // Redis metrics
  async getRedisMetrics(): Promise<{
    memory: {
      used: string;
      peak: string;
      fragmentation: number;
    };
    clients: {
      connected: number;
      blocked: number;
    };
    stats: {
      totalCommands: number;
      commandsPerSecond: number;
      keyspaceHits: number;
      keyspaceMisses: number;
      hitRate: number;
    };
    keys: {
      total: number;
      expired: number;
      evicted: number;
    };
  }> {
    try {
      const info = await this.redis.info();
      const stats = this.parseRedisInfo(info);

      return {
        memory: {
          used: stats.used_memory_human || '0B',
          peak: stats.used_memory_peak_human || '0B',
          fragmentation: parseFloat(stats.mem_fragmentation_ratio) || 0,
        },
        clients: {
          connected: parseInt(stats.connected_clients) || 0,
          blocked: parseInt(stats.blocked_clients) || 0,
        },
        stats: {
          totalCommands: parseInt(stats.total_commands_processed) || 0,
          commandsPerSecond: parseFloat(stats.instantaneous_ops_per_sec) || 0,
          keyspaceHits: parseInt(stats.keyspace_hits) || 0,
          keyspaceMisses: parseInt(stats.keyspace_misses) || 0,
          hitRate: this.calculateHitRate(
            parseInt(stats.keyspace_hits) || 0,
            parseInt(stats.keyspace_misses) || 0
          ),
        },
        keys: {
          total: this.getTotalKeys(stats),
          expired: parseInt(stats.expired_keys) || 0,
          evicted: parseInt(stats.evicted_keys) || 0,
        },
      };
    } catch (error) {
      this.logger.error('Error getting Redis metrics:', error);
      return {
        memory: { used: '0B', peak: '0B', fragmentation: 0 },
        clients: { connected: 0, blocked: 0 },
        stats: { totalCommands: 0, commandsPerSecond: 0, keyspaceHits: 0, keyspaceMisses: 0, hitRate: 0 },
        keys: { total: 0, expired: 0, evicted: 0 },
      };
    }
  }

  // Custom metrics tracking
  trackMetric(name: string, value: number, tags?: Record<string, string>): void {
    const timestamp = Date.now();
    const metric = {
      name,
      value,
      tags: tags || {},
      timestamp,
    };

    this.metrics.set(`${name}_${timestamp}`, metric);
    
    // Store in Redis for persistence
    this.redis.lpush(`metrics:${name}`, JSON.stringify(metric));
    this.redis.expire(`metrics:${name}`, 86400); // Keep for 24 hours
  }

  async getMetricHistory(name: string, hours: number = 24): Promise<any[]> {
    try {
      const cutoff = Date.now() - (hours * 60 * 60 * 1000);
      const metrics = await this.redis.lrange(`metrics:${name}`, 0, -1);
      
      return metrics
        .map(metric => JSON.parse(metric))
        .filter(metric => metric.timestamp > cutoff)
        .sort((a, b) => a.timestamp - b.timestamp);
    } catch (error) {
      this.logger.error(`Error getting metric history for ${name}:`, error);
      return [];
    }
  }

  // Performance timing
  startTimer(name: string): () => void {
    const start = process.hrtime.bigint();
    
    return () => {
      const end = process.hrtime.bigint();
      const duration = Number(end - start) / 1000000; // Convert to milliseconds
      
      this.trackMetric(`${name}_duration`, duration);
      this.trackMetric(`${name}_count`, 1);
      
      return duration;
    };
  }

  // Health check
  async healthCheck(): Promise<{
    status: 'healthy' | 'degraded' | 'unhealthy';
    checks: {
      database: boolean;
      redis: boolean;
      memory: boolean;
      cpu: boolean;
    };
    details: any;
  }> {
    const checks = {
      database: await this.checkDatabaseHealth(),
      redis: await this.checkRedisHealth(),
      memory: this.checkMemoryHealth(),
      cpu: this.checkCPUHealth(),
    };

    const healthyChecks = Object.values(checks).filter(Boolean).length;
    const totalChecks = Object.keys(checks).length;

    let status: 'healthy' | 'degraded' | 'unhealthy';
    if (healthyChecks === totalChecks) {
      status = 'healthy';
    } else if (healthyChecks >= totalChecks * 0.5) {
      status = 'degraded';
    } else {
      status = 'unhealthy';
    }

    return {
      status,
      checks,
      details: {
        healthyChecks,
        totalChecks,
        timestamp: new Date().toISOString(),
      },
    };
  }

  // Alerting
  async checkAlerts(): Promise<{
    alerts: Array<{
      level: 'info' | 'warning' | 'error' | 'critical';
      message: string;
      metric: string;
      value: number;
      threshold: number;
    }>;
  }> {
    const alerts: any[] = [];
    const systemMetrics = await this.getSystemMetrics();
    const appMetrics = await this.getApplicationMetrics();

    // CPU usage alert
    if (systemMetrics.cpu.usage > 80) {
      alerts.push({
        level: 'warning',
        message: 'High CPU usage detected',
        metric: 'cpu_usage',
        value: systemMetrics.cpu.usage,
        threshold: 80,
      });
    }

    // Memory usage alert
    if (systemMetrics.memory.usage > 85) {
      alerts.push({
        level: 'warning',
        message: 'High memory usage detected',
        metric: 'memory_usage',
        value: systemMetrics.memory.usage,
        threshold: 85,
      });
    }

    // Disk usage alert
    if (systemMetrics.disk.usage > 90) {
      alerts.push({
        level: 'error',
        message: 'High disk usage detected',
        metric: 'disk_usage',
        value: systemMetrics.disk.usage,
        threshold: 90,
      });
    }

    // Event loop lag alert
    if (appMetrics.eventLoopLag > 100) {
      alerts.push({
        level: 'warning',
        message: 'High event loop lag detected',
        metric: 'event_loop_lag',
        value: appMetrics.eventLoopLag,
        threshold: 100,
      });
    }

    return { alerts };
  }

  // Helper methods
  private async getCPUUsage(): Promise<number> {
    const cpus = os.cpus();
    let totalIdle = 0;
    let totalTick = 0;

    for (const cpu of cpus) {
      for (const type in cpu.times) {
        totalTick += cpu.times[type as keyof typeof cpu.times];
      }
      totalIdle += cpu.times.idle;
    }

    return 100 - Math.round((totalIdle / totalTick) * 100);
  }

  private getMemoryInfo(): any {
    const total = os.totalmem();
    const free = os.freemem();
    const used = total - free;

    return {
      total,
      free,
      used,
      usage: Math.round((used / total) * 100),
    };
  }

  private async getDiskInfo(): Promise<any> {
    // This would use a library like 'node-disk-info' in a real implementation
    return {
      total: 0,
      free: 0,
      used: 0,
      usage: 0,
    };
  }

  private getNetworkInfo(): any {
    return {
      interfaces: os.networkInterfaces(),
    };
  }

  private async getEventLoopLag(): Promise<number> {
    return new Promise((resolve) => {
      const start = process.hrtime.bigint();
      setImmediate(() => {
        const end = process.hrtime.bigint();
        resolve(Number(end - start) / 1000000); // Convert to milliseconds
      });
    });
  }

  private parseRedisInfo(info: string): Record<string, string> {
    const lines = info.split('\r\n');
    const result: Record<string, string> = {};
    
    for (const line of lines) {
      if (line.includes(':')) {
        const [key, value] = line.split(':');
        result[key] = value;
      }
    }
    
    return result;
  }

  private calculateHitRate(hits: number, misses: number): number {
    const total = hits + misses;
    return total > 0 ? (hits / total) * 100 : 0;
  }

  private getTotalKeys(stats: Record<string, string>): number {
    let total = 0;
    for (const key in stats) {
      if (key.startsWith('db') && key.includes('keys')) {
        total += parseInt(stats[key]) || 0;
      }
    }
    return total;
  }

  private async checkDatabaseHealth(): Promise<boolean> {
    // This would check database connectivity
    return true;
  }

  private async checkRedisHealth(): Promise<boolean> {
    try {
      await this.redis.ping();
      return true;
    } catch (error) {
      return false;
    }
  }

  private checkMemoryHealth(): boolean {
    const memoryInfo = this.getMemoryInfo();
    return memoryInfo.usage < 90;
  }

  private checkCPUHealth(): boolean {
    // This would check CPU usage
    return true;
  }
}
