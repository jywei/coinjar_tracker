# CoinJar Price Tracker

A Ruby on Rails web application that tracks and displays cryptocurrency prices from the CoinJar Exchange API. The application captures real-time prices for Bitcoin (BTC) and Ethereum (ETH) and provides a price history.

## Features

### Core Functionality
- **Real-time Price Capture**: Fetch current prices from CoinJar Exchange API
- **Price History**: View historical price data with pagination
- **Price Details**: Display last, bid, ask prices with spread calculations

### Performance Optimizations
- **Caching**: Intelligent caching of currency lists and price data
- **Pagination**: Efficient pagination for large datasets
- **Error Handling**: Robust error handling for API failures

### User Interface
- **Responsive Design**: Bootstrap responsive UI
- **Real-time Updates**: Capture button for immediate price updates
- **Navigation**: Easy navigation between currencies and history
- **Data Visualization**: Clear presentation of price data and trends

## Technology Stack

- **Backend**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **Caching**: Rails.cache with solid_cache
- **Pagination**: Kaminari
- **Testing**: Minitest with WebMock for HTTP mocking
- **Styling**: Bootstrap 5.3.0

## API Integration

The application integrates with the CoinJar Exchange API:
- **Endpoint**: `https://data.exchange.coinjar.com/products/{SYMBOL}/ticker`
- **Supported Symbols**: BTCAUD, ETHAUD
- **Data Captured**: last, bid, ask prices
- **Error Handling**: Error handling for network issues, timeouts, and API errors

## Installation & Setup

### Prerequisites
- Ruby 3.3.0 or higher
- PostgreSQL

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd coinjar_tracker
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start the server**
   ```bash
   bin/rails server
   ```

5. **Visit the application**
   Open http://localhost:3000 in your browser


## Usage

### Capturing Prices
1. Navigate to the home page
2. Click the "Capture Latest Prices" button
3. The application will fetch current prices from CoinJar API
4. View the updated prices in the table

### Viewing Price History
1. Click "View History" for any currency
2. Browse through paginated price snapshots
3. View detailed price information including spreads

### All Price History
1. Click "View All Price History" from the main page
2. See all captured prices across all currencies
3. Navigate through pages of historical data

## Testing

The application includes comprehensive test coverage:

### Running Tests
```bash
# Run all tests
bin/rails test
```

### Test Coverage
- **Model Tests**: Validations, associations, scopes, and methods
- **Service Tests**: API integration, error handling, data processing
- **Controller Tests**: HTTP responses, caching, pagination
- **Integration Tests**: End-to-end functionality

## Performance Features

### Caching Strategy
- **Currency List**: Cached for 5 minutes with automatic invalidation
- **Price Data**: Intelligent caching with cache key management
- **Cache Invalidation**: Automatic cache clearing on price updates

### Database Optimization
- **Indexes**: Proper indexing on frequently queried columns
- **Eager Loading**: Optimized queries with includes
- **Pagination**: Efficient pagination for large datasets

### Error Handling
- **API Failures**: Graceful handling of network and API errors
- **Partial Failures**: Continue processing when some currencies fail
- **User Feedback**: Clear error messages and status updates

## Architecture Decisions

### Service Layer Pattern
- **PriceCaptureService**: Focuses on business logic for price capture operations
- **CoinjarApiClient**: Dedicated HTTP client for API communication
- **Separation of Concerns**: Clear separation between API communication and business logic
- **Error Handling**: Centralized error handling with custom error classes

### Model Design
- **Validations**: Comprehensive data validation
- **Scopes**: Reusable query scopes for common operations
- **Methods**: Business logic methods for price calculations

### Controller Design
- **RESTful Routes**: Standard RESTful routing
- **Caching**: Strategic caching for performance
- **Error Handling**: User-friendly error messages

## 🤖 AI Assistance

This project was developed with the assistance of AI tools, specifically:

### AI Tools Used
- **Cursor.sh**: Primary development environment with AI assistance
- **ChatGPT**: Code review, architecture suggestions, and problem-solving

### AI Contributions
- **Initial Scaffolding**: AI helped generate the basic Rails application structure
- **Layout Styling**: AI helped building simple bootstrap layouts
- **Testing Strategy**: AI helped design comprehensive test coverage

## 🚀 Optional Enhancements (Not Implemented)

The original challenge included several optional enhancements. I chose to implement **Performance Optimizations** (caching and pagination), but here are the other enhancements and how I would approach implementing them:

### 1. Price Alerts
**Description**: Allow users to set price thresholds and notify when crossed

**Required Components**:
- Database migration for `price_alerts` table
- Alert creation/deletion/edition pages
- Service to check alerts after price captures
- Notifications like email or SMS (or push notification)

### 2. Price Visualization
**Description**: Add a simple chart showing price trends over time

**Required Components**:
- Chartkick gem https://github.com/ankane/chartkick integration

### 3. Additional Currencies
**Description**: Expand beyond BTC and ETH to include other cryptocurrencies

**Required Components**:
- Update seed data with more currencies
- Rate limit if necessary

### 4. Scheduled Updates
**Description**: Add automated price captures at regular intervals

**Required Components**:
- Background job (Sidekiq or Active Job)
- Cron scheduling with whenever gem https://github.com/javan/whenever

### 5. Advanced Performance Optimizations
**Description**: Implement additional caching and pagination improvements

**Required Components**:
- Redis server
- Database index
- Performance monitoring tools

### Technical Considerations

- **API Rate Limits**: CoinJar API has rate limits that need to be respected
- **Data Storage**: Large datasets require careful database design
- **Real-time Updates**: WebSocket integration for live price updates
- **Mobile Responsiveness**: Charts and alerts need mobile-friendly design

### Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_ENV`: Environment (development, production, test)
