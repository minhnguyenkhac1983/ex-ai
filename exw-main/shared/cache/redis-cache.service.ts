import { Injectable, Logger } from '@nestjs/common';
import { Redis } from 'ioredis';

@Injectable()
export class RedisCacheService {
  private readonly logger = new Logger(RedisCacheService.name);
  private redis: Redis;

  constructor() {
    this.redis = new Redis({
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT) || 6379,
      retryDelayOnFailover: 100,
      maxRetriesPerRequest: 3,
      lazyConnect: true,
      keepAlive: 30000,
      connectTimeout: 10000,
      commandTimeout: 5000,
    });

    this.redis.on('connect', () => {
      this.logger.log('Redis connected successfully');
    });

    this.redis.on('error', (error) => {
      this.logger.error('Redis connection error:', error);
    });
  }

  // Basic cache operations
  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      this.logger.error(`Error getting cache key ${key}:`, error);
      return null;
    }
  }

  async set(key: string, value: any, ttl?: number): Promise<boolean> {
    try {
      const serializedValue = JSON.stringify(value);
      if (ttl) {
        await this.redis.setex(key, ttl, serializedValue);
      } else {
        await this.redis.set(key, serializedValue);
      }
      return true;
    } catch (error) {
      this.logger.error(`Error setting cache key ${key}:`, error);
      return false;
    }
  }

  async del(key: string): Promise<boolean> {
    try {
      await this.redis.del(key);
      return true;
    } catch (error) {
      this.logger.error(`Error deleting cache key ${key}:`, error);
      return false;
    }
  }

  async exists(key: string): Promise<boolean> {
    try {
      const result = await this.redis.exists(key);
      return result === 1;
    } catch (error) {
      this.logger.error(`Error checking cache key ${key}:`, error);
      return false;
    }
  }

  // Advanced cache operations
  async mget<T>(keys: string[]): Promise<(T | null)[]> {
    try {
      const values = await this.redis.mget(...keys);
      return values.map(value => value ? JSON.parse(value) : null);
    } catch (error) {
      this.logger.error(`Error getting multiple cache keys:`, error);
      return keys.map(() => null);
    }
  }

  async mset(keyValuePairs: Record<string, any>, ttl?: number): Promise<boolean> {
    try {
      const serializedPairs: string[] = [];
      for (const [key, value] of Object.entries(keyValuePairs)) {
        serializedPairs.push(key, JSON.stringify(value));
      }
      
      await this.redis.mset(...serializedPairs);
      
      if (ttl) {
        const pipeline = this.redis.pipeline();
        for (const key of Object.keys(keyValuePairs)) {
          pipeline.expire(key, ttl);
        }
        await pipeline.exec();
      }
      
      return true;
    } catch (error) {
      this.logger.error(`Error setting multiple cache keys:`, error);
      return false;
    }
  }

  // Hash operations
  async hget<T>(key: string, field: string): Promise<T | null> {
    try {
      const value = await this.redis.hget(key, field);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      this.logger.error(`Error getting hash field ${field} from ${key}:`, error);
      return null;
    }
  }

  async hset(key: string, field: string, value: any): Promise<boolean> {
    try {
      await this.redis.hset(key, field, JSON.stringify(value));
      return true;
    } catch (error) {
      this.logger.error(`Error setting hash field ${field} in ${key}:`, error);
      return false;
    }
  }

  async hgetall<T>(key: string): Promise<Record<string, T>> {
    try {
      const hash = await this.redis.hgetall(key);
      const result: Record<string, T> = {};
      for (const [field, value] of Object.entries(hash)) {
        result[field] = JSON.parse(value);
      }
      return result;
    } catch (error) {
      this.logger.error(`Error getting all hash fields from ${key}:`, error);
      return {};
    }
  }

  // List operations
  async lpush(key: string, ...values: any[]): Promise<number> {
    try {
      const serializedValues = values.map(value => JSON.stringify(value));
      return await this.redis.lpush(key, ...serializedValues);
    } catch (error) {
      this.logger.error(`Error pushing to list ${key}:`, error);
      return 0;
    }
  }

  async rpop<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.rpop(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      this.logger.error(`Error popping from list ${key}:`, error);
      return null;
    }
  }

  async lrange<T>(key: string, start: number, stop: number): Promise<T[]> {
    try {
      const values = await this.redis.lrange(key, start, stop);
      return values.map(value => JSON.parse(value));
    } catch (error) {
      this.logger.error(`Error getting list range from ${key}:`, error);
      return [];
    }
  }

  // Set operations
  async sadd(key: string, ...members: any[]): Promise<number> {
    try {
      const serializedMembers = members.map(member => JSON.stringify(member));
      return await this.redis.sadd(key, ...serializedMembers);
    } catch (error) {
      this.logger.error(`Error adding to set ${key}:`, error);
      return 0;
    }
  }

  async smembers<T>(key: string): Promise<T[]> {
    try {
      const members = await this.redis.smembers(key);
      return members.map(member => JSON.parse(member));
    } catch (error) {
      this.logger.error(`Error getting set members from ${key}:`, error);
      return [];
    }
  }

  // Sorted set operations
  async zadd(key: string, score: number, member: any): Promise<number> {
    try {
      return await this.redis.zadd(key, score, JSON.stringify(member));
    } catch (error) {
      this.logger.error(`Error adding to sorted set ${key}:`, error);
      return 0;
    }
  }

  async zrange<T>(key: string, start: number, stop: number): Promise<T[]> {
    try {
      const members = await this.redis.zrange(key, start, stop);
      return members.map(member => JSON.parse(member));
    } catch (error) {
      this.logger.error(`Error getting sorted set range from ${key}:`, error);
      return [];
    }
  }

  // Cache patterns
  async getOrSet<T>(
    key: string,
    fetchFunction: () => Promise<T>,
    ttl?: number
  ): Promise<T> {
    try {
      // Try to get from cache first
      const cached = await this.get<T>(key);
      if (cached !== null) {
        return cached;
      }

      // If not in cache, fetch from source
      const value = await fetchFunction();
      
      // Store in cache
      await this.set(key, value, ttl);
      
      return value;
    } catch (error) {
      this.logger.error(`Error in getOrSet for key ${key}:`, error);
      // Fallback to fetch function if cache fails
      return await fetchFunction();
    }
  }

  async invalidatePattern(pattern: string): Promise<number> {
    try {
      const keys = await this.redis.keys(pattern);
      if (keys.length > 0) {
        return await this.redis.del(...keys);
      }
      return 0;
    } catch (error) {
      this.logger.error(`Error invalidating pattern ${pattern}:`, error);
      return 0;
    }
  }

  // Cache warming
  async warmCache<T>(
    keys: string[],
    fetchFunction: (key: string) => Promise<T>,
    ttl?: number
  ): Promise<void> {
    try {
      const pipeline = this.redis.pipeline();
      
      for (const key of keys) {
        const value = await fetchFunction(key);
        pipeline.set(key, JSON.stringify(value));
        if (ttl) {
          pipeline.expire(key, ttl);
        }
      }
      
      await pipeline.exec();
    } catch (error) {
      this.logger.error('Error warming cache:', error);
    }
  }

  // Cache statistics
  async getStats(): Promise<{
    usedMemory: string;
    connectedClients: number;
    totalCommandsProcessed: number;
    keyspaceHits: number;
    keyspaceMisses: number;
    hitRate: number;
  }> {
    try {
      const info = await this.redis.info();
      const stats = this.parseRedisInfo(info);
      
      return {
        usedMemory: stats.used_memory_human || '0B',
        connectedClients: parseInt(stats.connected_clients) || 0,
        totalCommandsProcessed: parseInt(stats.total_commands_processed) || 0,
        keyspaceHits: parseInt(stats.keyspace_hits) || 0,
        keyspaceMisses: parseInt(stats.keyspace_misses) || 0,
        hitRate: this.calculateHitRate(
          parseInt(stats.keyspace_hits) || 0,
          parseInt(stats.keyspace_misses) || 0
        ),
      };
    } catch (error) {
      this.logger.error('Error getting cache stats:', error);
      return {
        usedMemory: '0B',
        connectedClients: 0,
        totalCommandsProcessed: 0,
        keyspaceHits: 0,
        keyspaceMisses: 0,
        hitRate: 0,
      };
    }
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

  // Health check
  async healthCheck(): Promise<boolean> {
    try {
      await this.redis.ping();
      return true;
    } catch (error) {
      this.logger.error('Redis health check failed:', error);
      return false;
    }
  }

  // Close connection
  async close(): Promise<void> {
    try {
      await this.redis.quit();
    } catch (error) {
      this.logger.error('Error closing Redis connection:', error);
    }
  }
}
