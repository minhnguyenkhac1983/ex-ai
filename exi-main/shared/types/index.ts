// User Types
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone?: string;
  role: UserRole;
  status: UserStatus;
  emailVerified: boolean;
  createdAt: string;
  updatedAt: string;
}

export enum UserRole {
  CUSTOMER = 'customer',
  BROKER = 'broker',
  PROVIDER = 'provider',
  ADMIN = 'admin'
}

export enum UserStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  SUSPENDED = 'suspended',
  PENDING = 'pending'
}

// Insurance Provider Types
export interface InsuranceProvider {
  id: string;
  name: string;
  code: string;
  description?: string;
  website?: string;
  contactEmail?: string;
  contactPhone?: string;
  status: ProviderStatus;
  createdAt: string;
  updatedAt: string;
}

export enum ProviderStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  PENDING = 'pending'
}

// Insurance Product Types
export interface InsuranceProduct {
  id: string;
  providerId: string;
  name: string;
  type: InsuranceType;
  description?: string;
  coverageDetails: CoverageDetails;
  pricingRules: PricingRules;
  status: ProductStatus;
  createdAt: string;
  updatedAt: string;
}

export enum InsuranceType {
  AUTO = 'auto',
  HOME = 'home',
  LIFE = 'life',
  HEALTH = 'health',
  BUSINESS = 'business',
  TRAVEL = 'travel'
}

export interface CoverageDetails {
  liability?: number;
  collision?: boolean;
  comprehensive?: boolean;
  roadside?: boolean;
  property?: number;
  personalProperty?: number;
  coverageAmount?: number;
  termLength?: number;
  premiumType?: string;
  [key: string]: any;
}

export interface PricingRules {
  basePremium: number;
  factors: PricingFactor[];
  discounts: Discount[];
  [key: string]: any;
}

export interface PricingFactor {
  name: string;
  value: number;
  type: 'multiplier' | 'addition' | 'percentage';
}

export interface Discount {
  name: string;
  value: number;
  type: 'percentage' | 'fixed';
  conditions: string[];
}

export enum ProductStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  DRAFT = 'draft'
}

// Policy Types
export interface Policy {
  id: string;
  userId: string;
  productId: string;
  policyNumber: string;
  status: PolicyStatus;
  startDate: string;
  endDate: string;
  premiumAmount: number;
  coverageAmount: number;
  policyDetails: PolicyDetails;
  createdAt: string;
  updatedAt: string;
}

export enum PolicyStatus {
  ACTIVE = 'active',
  EXPIRED = 'expired',
  CANCELLED = 'cancelled',
  PENDING = 'pending',
  SUSPENDED = 'suspended'
}

export interface PolicyDetails {
  insuredItems: InsuredItem[];
  beneficiaries?: Beneficiary[];
  riders?: Rider[];
  [key: string]: any;
}

export interface InsuredItem {
  id: string;
  type: string;
  description: string;
  value: number;
  details: Record<string, any>;
}

export interface Beneficiary {
  id: string;
  name: string;
  relationship: string;
  percentage: number;
}

export interface Rider {
  id: string;
  name: string;
  description: string;
  cost: number;
}

// Claim Types
export interface Claim {
  id: string;
  policyId: string;
  userId: string;
  claimNumber: string;
  status: ClaimStatus;
  claimType: string;
  description: string;
  incidentDate: string;
  reportedDate: string;
  estimatedAmount?: number;
  approvedAmount?: number;
  claimDetails: ClaimDetails;
  createdAt: string;
  updatedAt: string;
}

export enum ClaimStatus {
  PENDING = 'pending',
  UNDER_REVIEW = 'under_review',
  APPROVED = 'approved',
  DENIED = 'denied',
  PAID = 'paid',
  CLOSED = 'closed'
}

export interface ClaimDetails {
  incidentLocation?: string;
  witnesses?: string[];
  policeReport?: string;
  medicalReports?: string[];
  repairEstimates?: RepairEstimate[];
  [key: string]: any;
}

export interface RepairEstimate {
  id: string;
  vendor: string;
  amount: number;
  description: string;
  date: string;
}

// Payment Types
export interface Payment {
  id: string;
  userId: string;
  policyId: string;
  amount: number;
  paymentMethod: PaymentMethod;
  status: PaymentStatus;
  transactionId?: string;
  paymentDate?: string;
  createdAt: string;
  updatedAt: string;
}

export enum PaymentMethod {
  CREDIT_CARD = 'credit_card',
  DEBIT_CARD = 'debit_card',
  BANK_TRANSFER = 'bank_transfer',
  CHECK = 'check',
  CASH = 'cash'
}

export enum PaymentStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
  REFUNDED = 'refunded'
}

// Quote Types
export interface Quote {
  id: string;
  userId: string;
  productId: string;
  quoteNumber: string;
  premiumAmount: number;
  coverageAmount: number;
  quoteDetails: QuoteDetails;
  validUntil: string;
  status: QuoteStatus;
  createdAt: string;
}

export enum QuoteStatus {
  ACTIVE = 'active',
  EXPIRED = 'expired',
  ACCEPTED = 'accepted',
  DECLINED = 'declined'
}

export interface QuoteDetails {
  coverageOptions: CoverageOption[];
  discounts: Discount[];
  totalPremium: number;
  monthlyPremium: number;
  [key: string]: any;
}

export interface CoverageOption {
  name: string;
  description: string;
  amount: number;
  selected: boolean;
}

// Document Types
export interface Document {
  id: string;
  userId: string;
  policyId?: string;
  claimId?: string;
  documentType: DocumentType;
  fileName: string;
  filePath: string;
  fileSize?: number;
  mimeType?: string;
  uploadedAt: string;
}

export enum DocumentType {
  POLICY_DOCUMENT = 'policy_document',
  CLAIM_DOCUMENT = 'claim_document',
  ID_DOCUMENT = 'id_document',
  PROOF_OF_INSURANCE = 'proof_of_insurance',
  MEDICAL_REPORT = 'medical_report',
  REPAIR_ESTIMATE = 'repair_estimate',
  OTHER = 'other'
}

// Notification Types
export interface Notification {
  id: string;
  userId: string;
  type: NotificationType;
  title: string;
  message: string;
  read: boolean;
  sentAt: string;
}

export enum NotificationType {
  POLICY_UPDATE = 'policy_update',
  CLAIM_UPDATE = 'claim_update',
  PAYMENT_REMINDER = 'payment_reminder',
  SYSTEM_ALERT = 'system_alert',
  MARKETING = 'marketing'
}

// API Response Types
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
  errors?: ValidationError[];
}

export interface ValidationError {
  field: string;
  message: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: Pagination;
}

export interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

// Authentication Types
export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
}

export interface AuthResponse {
  user: User;
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

// Search and Filter Types
export interface SearchFilters {
  query?: string;
  type?: InsuranceType;
  provider?: string;
  minPrice?: number;
  maxPrice?: number;
  status?: string;
  dateFrom?: string;
  dateTo?: string;
}

export interface SortOptions {
  field: string;
  direction: 'asc' | 'desc';
}

// Dashboard Types
export interface DashboardStats {
  totalPolicies: number;
  activePolicies: number;
  totalClaims: number;
  pendingClaims: number;
  totalPremium: number;
  monthlyPremium: number;
  recentActivity: ActivityItem[];
}

export interface ActivityItem {
  id: string;
  type: string;
  description: string;
  timestamp: string;
  userId: string;
  userName: string;
}
