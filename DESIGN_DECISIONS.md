# Design Decisions & Architecture Documentation

## Addressing Feedback Points

This document articulates the design decisions made in the CoinJar Price Tracker application and addresses the specific feedback points received.

## 1. Database-Level Constraints vs Model Validations

**Decision**: Move uniqueness constraints from model validations to database schema.

## 2. Database Indexing Strategy

**Decision**: Add strategic indexes for performance optimization.

## 3. N+1 Query Prevention

**Decision**: Use eager loading and optimized queries to prevent N+1 problems.

## 4. Service Layer Error Handling

**Decision**: Replace broad exception handling with specific error types.

## 5. Testing Strategy

**Decision**: Use Rails' transactional testing instead of manual data cleanup.

## 6. Caching Strategy

**Decision**: Implement intelligent caching with proper invalidation.

## 7. API Client Design

**Decision**: Create a dedicated API client with comprehensive error handling.

## 8. Data Types and Constraints

**Decision**: Use appropriate data types and constraints for cryptocurrency data.

## Performance Considerations

### Database Performance
- Indexing reduces query execution time

### Application Performance
- Eager loading prevents N+1 queries
- Caching reduces database load

### Scalability
- Efficient indexing supports large datasets
- Proper error handling improves system reliability

## Code Quality Improvements

### Maintainability
- Clear separation of concerns in service layer
- Specific error handling for better debugging

### Reliability
- Database-level constraints prevent data corruption
- Proper error handling for external API failures

### Performance
- Strategic caching reduces response times
- Indexing supports efficient data access

## Conclusion

1. **Moving constraints to database level** for better data integrity
2. **Adding strategic indexes** for performance optimization
3. **Preventing N+1 queries** through proper eager loading
4. **Implementing specific error handling** for better debugging
5. **Using transactional testing** for reliable test execution
6. **Creating comprehensive documentation** of design decisions
