# Finance Management Mobile Application

Production-ready fintech baseline for small finance businesses with Flutter + FastAPI + PostgreSQL.

## Features
- JWT authentication with password hashing
- Admin dashboard with KPIs and recent transactions
- Customer CRUD with search
- Loan creation and tracking
- EMI payment tracking and receipt PDF generation
- Daily/weekly/monthly reporting endpoints
- Clean modular architecture (frontend and backend)
- Supabase PostgreSQL compatible schema
- Render deployment config

## Project Structure

- `finance_app/` Flutter app
- `backend/` FastAPI backend
- `render.yaml` Render deployment configuration

### Flutter Structure
- `lib/screens`
- `lib/widgets`
- `lib/services`
- `lib/models`
- `lib/providers`
- `lib/routes`
- `lib/utils`
- `lib/themes`

### Backend Structure
- `backend/app/routes`
- `backend/app/services`
- `backend/app/models`
- `backend/app/database`
- `backend/app/middleware`
- `backend/app/schemas`
- `backend/app/utils`

## Backend Setup
1. `cd backend`
2. `python -m venv .venv`
3. Windows: `.venv\\Scripts\\activate`
4. `pip install -r requirements.txt`
5. `copy .env.example .env` and fill credentials
6. Run SQL in `database_schema.sql` on Supabase SQL editor (optional if using ORM auto-create)
7. `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`

API docs:
- Swagger: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

Default seeded login:
- Username: `admin`
- Password: `admin12345`

## Flutter Setup
1. Install Flutter stable SDK
2. `cd finance_app`
3. `flutter pub get`
4. `flutter run --dart-define=API_BASE_URL=http://<your-backend-host>/api`

## Core APIs
- `POST /api/auth/login`
- `POST /api/auth/register`
- `GET/POST /api/customers`
- `PUT/DELETE /api/customers/{id}`
- `GET/POST /api/loans`
- `GET/POST /api/payments`
- `GET /api/payments/{payment_id}/receipt`
- `GET /api/reports/dashboard`
- `GET /api/reports/daily`
- `GET /api/reports/weekly`
- `GET /api/reports/monthly`

## Render Deployment
1. Push project to GitHub.
2. In Render, create new Blueprint and select repo.
3. Render reads `render.yaml` and creates `finance-backend` service.
4. Add env vars: `DATABASE_URL`, `SECRET_KEY`, `CORS_ORIGINS`.
5. Deploy.

## Supabase Configuration
1. Create Supabase project.
2. Open SQL editor and run `backend/database_schema.sql`.
3. Copy connection string and set `DATABASE_URL` in backend `.env` and Render env vars.

## Security Notes
- Use strong `SECRET_KEY` in production.
- Enforce HTTPS at ingress/load balancer level.
- Restrict CORS origins to your app domains.
- Rotate credentials and monitor API usage.

## Performance and Scalability
- Async FastAPI + SQLAlchemy
- Indexed search columns
- Riverpod-driven state isolation
- Service-layer abstractions for extension
- Ready for modular expansion (notifications, audit, advanced analytics)

## Next Recommended Enhancements
- Alembic migrations
- Token refresh/blacklist
- Better offline sync queue
- Role-based permissions
- Automated tests and CI/CD
