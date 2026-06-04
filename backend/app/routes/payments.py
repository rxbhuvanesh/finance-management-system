from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.middleware.auth import get_current_user
from app.schemas.finance import PaymentCreate, PaymentOut
from app.services.finance_service import build_receipt_pdf, create_payment, list_payments

router = APIRouter(prefix="/payments", tags=["payments"], dependencies=[Depends(get_current_user)])


@router.get("", response_model=list[PaymentOut])
async def get_payments(db: AsyncSession = Depends(get_db)):
    return await list_payments(db)


@router.post("", response_model=PaymentOut)
async def add_payment(payload: PaymentCreate, db: AsyncSession = Depends(get_db)):
    return await create_payment(db, payload)


@router.get("/{payment_id}/receipt")
async def payment_receipt(payment_id: int, db: AsyncSession = Depends(get_db)):
    payments = await list_payments(db)
    payment = next((p for p in payments if p.id == payment_id), None)
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    pdf_bytes = build_receipt_pdf(payment.id, float(payment.amount), payment.paid_on, payment.loan_id)
    return StreamingResponse(iter([pdf_bytes]), media_type="application/pdf")
