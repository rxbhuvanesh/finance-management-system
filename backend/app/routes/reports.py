from datetime import date, timedelta
from fastapi import APIRouter, Depends
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.middleware.auth import get_current_user
from app.models.finance import Payment
from app.services.finance_service import dashboard_summary

router = APIRouter(prefix="/reports", tags=["reports"], dependencies=[Depends(get_current_user)])


@router.get("/dashboard")
async def get_dashboard(db: AsyncSession = Depends(get_db)):
    return await dashboard_summary(db)


@router.get("/daily")
async def daily_report(db: AsyncSession = Depends(get_db)):
    today = date.today().isoformat()
    amount = (await db.execute(select(func.coalesce(func.sum(Payment.amount), 0)).where(Payment.paid_on == today))).scalar() or 0
    return {"date": today, "total_collection": float(amount)}


@router.get("/weekly")
async def weekly_report(db: AsyncSession = Depends(get_db)):
    today = date.today()
    week_ago = (today - timedelta(days=7)).isoformat()
    amount = (await db.execute(select(func.coalesce(func.sum(Payment.amount), 0)).where(Payment.paid_on >= week_ago))).scalar() or 0
    return {"from": week_ago, "to": today.isoformat(), "total_collection": float(amount)}


@router.get("/monthly")
async def monthly_report(db: AsyncSession = Depends(get_db)):
    month_prefix = date.today().strftime("%Y-%m")
    rows = (await db.execute(select(Payment.paid_on, func.coalesce(func.sum(Payment.amount), 0)).where(Payment.paid_on.like(f"{month_prefix}%")).group_by(Payment.paid_on).order_by(Payment.paid_on))).all()
    return [{"date": day, "amount": float(amount)} for day, amount in rows]
