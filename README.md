# CoinJar Price Tracker

A Rails application for tracking cryptocurrency prices from the CoinJar exchange API.

## Design Decisions & Architecture

### Database Design

**Uniqueness Constraints at Database Level**
- Added database-level unique indexes on `currencies.name` and `currencies.symbol` instead of relying solely on model validations
- This ensures data integrity at the database level and prevents race conditions
- Model validations remain for user feedback but database constraints are the source of truth

**Indexing Strategy**
- Added composite index on `price_snapshots(currency_id, captured_at)` for efficient latest price queries
- Added index on `price_snapshots.captured_at` for time-based queries
- These indexes optimize the most common query patterns: finding latest prices and filtering by time

**Data Types & Constraints**
- Used `decimal` with precision 20, scale 8 for price fields to handle cryptocurrency precision
- Added `null: false` constraints to prevent invalid data
- Foreign key constraints ensure referential integrity

### Performance Optimizations

**N+1 Query Prevention**
- Used `includes(:price_snapshots)` in controllers to preload associations
- Optimized `latest_price` method with `limit(1)` to reduce query complexity
- Added `with_latest_price` scope for efficient bulk latest price queries

**Caching Strategy**
- Implemented 1-minute cache for currency listings with latest prices
- Cache invalidation on price capture to ensure data freshness
- Used `Rails.cache.delete_matched` for targeted cache clearing

### Service Layer Design

**Error Handling Philosophy**
- Replaced broad `StandardError` rescues with specific exception types
- `CoinjarApiClient::ApiError` for HTTP/network issues
- `CoinjarApiClient::InvalidResponseError` for malformed API responses
- `ActiveRecord::RecordInvalid` for validation failures
- This provides better error categorization and appropriate logging levels

**API Client Design**
- Single responsibility: handles HTTP communication with CoinJar API
- Comprehensive error handling for different HTTP status codes
- Input validation for API responses
- Timeout handling for network reliability

**Price Capture Service**
- Orchestrates the price capture process
- Handles individual currency failures gracefully
- Provides detailed error reporting
- Maintains audit trail through logging

### Testing Strategy

**Transactional Testing**
- Removed manual `destroy_all` calls in favor of Rails' automatic transaction rollback
- Tests run in database transactions that are rolled back after each test
- This ensures test isolation and faster test execution

**Test Organization**
- Model tests focus on validations, associations, and business logic
- Service tests verify external API integration
- Controller tests ensure proper request handling and caching

### Code Quality

**Validation Strategy**
- Database constraints for data integrity
- Model validations for user experience
- Service-level validation for business rules

**Logging Strategy**
- Different log levels for different types of errors
- Structured error messages for debugging
- Success logging for audit trails

## Setup

1. Install dependencies: `bundle install`
2. Setup database: `bin/rails db:setup`
3. Start the server: `bin/rails server`

## Usage

- View all currencies: `/currencies`
- View currency details: `/currencies/:id`
- Capture latest prices: `/currencies/capture_prices`

## API Endpoints

- `GET /currencies` - List all currencies with latest prices
- `GET /currencies/:id` - Show currency details with price history
- `POST /currencies/capture_prices` - Capture latest prices for all currencies

## Performance Considerations

- Database indexes optimize common queries
- Caching reduces database load
- N+1 query prevention through proper includes
- Efficient pagination for large datasets
