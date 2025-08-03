# CoinJar Price Tracker

A Ruby on Rails web application that tracks and displays cryptocurrency prices from the CoinJar Exchange API. The application captures real-time prices for Bitcoin (BTC) and Ethereum (ETH) and provides a comprehensive price history with advanced features like caching and pagination.

## Features

### Core Functionality
- **Real-time Price Capture**: Fetch current prices from CoinJar Exchange API
- **Price History**: View historical price data with pagination
- **Multiple Currencies**: Support for BTC and ETH with easy extensibility
- **Price Details**: Display last, bid, ask prices with spread calculations

### Performance Optimizations
- **Caching**: Intelligent caching of currency lists and price data
- **Pagination**: Efficient pagination for large datasets
- **Database Optimization**: Proper indexing and query optimization
- **Error Handling**: Robust error handling for API failures

### User Interface
- **Responsive Design**: Bootstrap-based responsive UI
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
- **Deployment**: Docker with Kamal

## API Integration

The application integrates with the CoinJar Exchange API:
- **Endpoint**: `https://data.exchange.coinjar.com/products/{SYMBOL}/ticker`
- **Supported Symbols**: BTCAUD, ETHAUD
- **Data Captured**: last, bid, ask prices
- **Error Handling**: Comprehensive error handling for network issues, timeouts, and API errors

## Installation & Setup

### Prerequisites
- Ruby 3.3.0 or higher
- PostgreSQL
- Docker (optional)

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

### Docker Setup

1. **Build and run with Docker**
   ```bash
   docker build -t coinjar_tracker .
   docker run -p 3000:3000 coinjar_tracker
   ```

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

## Database Schema

### Currencies Table
- `id`: Primary key
- `name`: Currency name (e.g., "Bitcoin")
- `symbol`: API symbol (e.g., "BTCAUD")
- `created_at`, `updated_at`: Timestamps

### Price Snapshots Table
- `id`: Primary key
- `currency_id`: Foreign key to currencies
- `last`: Last traded price
- `bid`: Best bid price
- `ask`: Best ask price
- `captured_at`: Timestamp when price was captured
- `created_at`, `updated_at`: Timestamps

## Testing

The application includes comprehensive test coverage:

### Running Tests
```bash
# Run all tests
bin/rails test

# Run specific test files
bin/rails test test/models/currency_test.rb
bin/rails test test/services/price_capture_service_test.rb
bin/rails test test/controllers/currencies_controller_test.rb
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
- **PriceCaptureService**: Encapsulates API interaction logic
- **Separation of Concerns**: Clear separation between business logic and controllers
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
- **Service Design**: AI suggested the service layer pattern for API integration
- **Error Handling**: AI provided guidance on robust error handling strategies
- **Testing Strategy**: AI helped design comprehensive test coverage
- **Performance Optimization**: AI suggested caching and pagination strategies

### Manual Refinements
- **Code Quality**: Manual review and refinement of all AI-generated code
- **Architecture Decisions**: Final architectural decisions made after careful consideration
- **Testing**: Comprehensive manual testing and test case development
- **Documentation**: Manual creation of detailed documentation

### Learning Outcomes
- **Best Practices**: Understanding of Rails best practices and patterns
- **Error Handling**: Improved knowledge of robust error handling in web applications
- **Performance**: Better understanding of caching and optimization strategies
- **Testing**: Enhanced testing skills with comprehensive coverage

## Deployment

### Production Deployment
The application is configured for deployment using Kamal:

```bash
# Deploy to production
bin/kamal deploy
```

### Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_ENV`: Environment (development, production, test)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support or questions, please open an issue in the repository.
