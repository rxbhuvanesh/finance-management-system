from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.middleware.auth import get_current_user
from app.schemas.finance import LoanCreate, LoanOut
from app.services.finance_service import create_loan, list_loans

router = APIRouter(prefix="/loans", tags=["loans"], dependencies=[Depends(get_current_user)])


@router.get("", response_model=list[LoanOut])
async def get_loans(db: AsyncSession = Depends(get_db)):
    return await list_loans(db)


@router.post("", response_model=LoanOut)
async def add_loan(payload: LoanCreate, db: AsyncSession = Depends(get_db)):
    return await create_loan(db, payload)
