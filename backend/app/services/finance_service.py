from datetime import date
from io import BytesIO
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from sqlalchemy import Select, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.finance import Customer, Loan, Payment
from app.models.user import User
from app.schemas.customer import CustomerCreate, CustomerUpdate
from app.schemas.finance import LoanCreate, PaymentCreate
from app.utils.security import hash_password


async def seed_admin_if_missing(db: AsyncSession):
    result = await db.execute(select(User).where(User.username == "admin"))
    if result.scalar_one_or_none() is None:
        db.add(User(username="admin", hashed_password=hash_password("admin12345"), full_name="Administrator"))
        await db.commit()


async def create_customer(db: AsyncSession, payload: CustomerCreate):
    obj = Customer(**payload.model_dump())
    db.add(obj)
    await db.commit()
    await db.refresh(obj)
    return obj


async def list_customers(db: AsyncSession, search: str | None = None):
    stmt: Select = select(Customer)
    if search:
        like = f"%{search}%"
        stmt = stmt.where((Customer.name.ilike(like)) | (Customer.mobile_number.ilike(like)))
    data = await db.execute(stmt.order_by(Customer.created_at.desc()))
    return data.scalars().all()


async def update_customer(db: AsyncSession, customer_id: int, payload: CustomerUpdate):
    result = await db.execute(select(Customer).where(Customer.id == customer_id))
    obj = result.scalar_one_or_none()
    if not obj:
        return None
    for key, value in payload.model_dump().items():
        setattr(obj, key, value)
    await db.commit()
    await db.refresh(obj)
    return obj


async def delete_customer(db: AsyncSession, customer_id: int):
    result = await db.execute(select(Customer).where(Customer.id == customer_id))
    obj = result.scalar_one_or_none()
    if not obj:
        return False
    await db.delete(obj)
    await db.commit()
    return True


async def create_loan(db: AsyncSession, payload: LoanCreate):
    loan = Loan(**payload.model_dump())
    db.add(loan)
    await db.commit()
    await db.refresh(loan)
    return loan


async def list_loans(db: AsyncSession):
    result = await db.execute(select(Loan).order_by(Loan.created_at.desc()))
    return result.scalars().all()


async def create_payment(db: AsyncSession, payload: PaymentCreate):
    payment = Payment(**payload.model_dump())
    db.add(payment)
    await db.commit()
    await db.refresh(payment)
    return payment


async def list_payments(db: AsyncSession):
    result = await db.execute(select(Payment).order_by(Payment.created_at.desc()))
    return result.scalars().all()


async def dashboard_summary(db: AsyncSession):
    today = date.today().isoformat()
    total_customers = (await db.execute(select(func.count(Customer.id)))).scalar() or 0
    total_loan_amount = (await db.execute(select(func.coalesce(func.sum(Loan.principal_amount), 0)))).scalar() or 0
    today_emi = (await db.execute(select(func.coalesce(func.sum(Payment.amount), 0)).where(Payment.paid_on == today))).scalar() or 0

    loan_total = total_loan_amount
    paid_total = (await db.execute(select(func.coalesce(func.sum(Payment.amount), 0)))).scalar() or 0
    pending = max(float(loan_total) - float(paid_total), 0)

    recent = (await db.execute(select(Payment).order_by(Payment.created_at.desc()).limit(10))).scalars().all()

    return {
        "total_customers": total_customers,
        "total_loan_amount": float(total_loan_amount),
        "emi_collected_today": float(today_emi),
        "pending_collections": float(pending),
        "recent_transactions": [
            {"id": p.id, "loan_id": p.loan_id, "amount": float(p.amount), "paid_on": p.paid_on} for p in recent
        ],
    }


def build_receipt_pdf(payment_id: int, amount: float, date_text: str, loan_id: int) -> bytes:
    buffer = BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    c.setFont("Helvetica-Bold", 18)
    c.drawString(60, 790, "Finance EMI Receipt")
    c.setFont("Helvetica", 12)
    c.drawString(60, 750, f"Receipt ID: {payment_id}")
    c.drawString(60, 730, f"Loan ID: {loan_id}")
    c.drawString(60, 710, f"Amount Paid: INR {amount:.2f}")
    c.drawString(60, 690, f"Date: {date_text}")
    c.drawString(60, 670, "Status: Paid")
    c.showPage()
    c.save()
    return buffer.getvalue()
