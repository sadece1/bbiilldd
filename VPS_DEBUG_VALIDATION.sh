#!/bin/bash

echo "=========================================="
echo "GEAR VALIDATION DEBUG SCRIPT"
echo "=========================================="
echo ""

# 1. Check backend logs for validation errors
echo "1. Checking backend logs for validation errors..."
echo "----------------------------------------"
pm2 logs campscape-backend --lines 100 --nostream | grep -i "validation\|error\|Validation" | tail -20
echo ""

# 2. Check if backend is running
echo "2. Backend status:"
echo "----------------------------------------"
pm2 status
echo ""

# 3. Test API endpoint with sample data
echo "3. Testing API endpoint with sample data..."
echo "----------------------------------------"
TOKEN=$(pm2 logs campscape-backend --lines 200 --nostream | grep -oP 'token[^"]*' | head -1 || echo "")

if [ -z "$TOKEN" ]; then
    echo "⚠️  Token not found in logs. Testing without auth..."
    curl -X POST http://localhost:3000/api/gear \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test Gear",
            "description": "This is a test description that is long enough",
            "category_id": "00000000-0000-0000-0000-000000000000",
            "price_per_day": 100,
            "status": "for-sale"
        }' 2>&1 | head -50
else
    echo "Testing with token..."
    curl -X POST http://localhost:3000/api/gear \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -d '{
            "name": "Test Gear",
            "description": "This is a test description that is long enough",
            "category_id": "00000000-0000-0000-0000-000000000000",
            "price_per_day": 100,
            "status": "for-sale"
        }' 2>&1 | head -50
fi
echo ""

# 4. Check recent validation errors in detail
echo "4. Recent validation errors (detailed):"
echo "----------------------------------------"
pm2 logs campscape-backend --lines 200 --nostream | grep -A 10 -B 5 "Validation\|validation\|errors" | tail -30
echo ""

# 5. Check request body format
echo "5. Checking if multer is parsing FormData correctly..."
echo "----------------------------------------"
pm2 logs campscape-backend --lines 200 --nostream | grep -i "request body\|body:" | tail -10
echo ""

# 6. Check database connection
echo "6. Database connection status:"
echo "----------------------------------------"
pm2 logs campscape-backend --lines 50 --nostream | grep -i "database\|connection" | tail -5
echo ""

# 7. Check for TypeScript compilation errors
echo "7. Checking for TypeScript errors..."
echo "----------------------------------------"
cd /var/www/campscape/server
npm run build 2>&1 | grep -i "error\|warning" | head -20
echo ""

# 8. Show current gear route configuration
echo "8. Current gear route file (first 50 lines):"
echo "----------------------------------------"
head -50 /var/www/campscape/server/src/routes/gear.routes.ts
echo ""

# 9. Show validation schema
echo "9. Current validation schema:"
echo "----------------------------------------"
grep -A 30 "createGearSchema" /var/www/campscape/server/src/validators/gearValidator.ts | head -40
echo ""

# 10. Check environment variables
echo "10. Environment variables (sensitive ones hidden):"
echo "----------------------------------------"
pm2 env 0 | grep -E "NODE_ENV|PORT|DB_" | head -10
echo ""

echo "=========================================="
echo "DEBUG COMPLETE"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Check the validation errors above"
echo "2. Check browser console for detailed error messages"
echo "3. Run: pm2 logs campscape-backend --lines 500 | grep -i validation"
echo ""


