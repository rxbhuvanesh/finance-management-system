from sqlalchemy import ForeignKey, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.session import Base
from app.models.base import TimestampMixin


class Customer(Base, TimestampMixin):
    __tablename__ = "customers"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(120), index=True)
    mobile_number: Mapped[str] = mapped_column(String(15), index=True)
    address: Mapped[str] = mapped_column(Text())
    aadhaar_number: Mapped[str] = mapped_column(String(16), unique=True, index=True)
    notes: Mapped[str | None] = mapped_column(Text(), nullable=True)

    loans = relationship("Loan", back_populates="customer", cascade="all, delete-orphan")


class Loan(Base, TimestampMixin):
    __tablename__ = "loans"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    customer_id: Mapped[int] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), index=True)
    principal_amount: Mapped[float] = mapped_column(Numeric(12, 2))
    interest_percentage: Mapped[float] = mapped_column(Numeric(5, 2))
    emi_duration_months: Mapped[int]
    due_day: Mapped[int]
    status: Mapped[str] = mapped_column(String(32), default="active", index=True)

    customer = relationship("Customer", back_populates="loans")
    payments = relationship("Payment", back_populates="loan", cascade="all, delete-orphan")


class Payment(Base, TimestampMixin):
    __tablename__ = "payments"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    loan_id: Mapped[int] = mapped_column(ForeignKey("loans.id", ondelete="CASCADE"), index=True)
    amount: Mapped[float] = mapped_column(Numeric(12, 2))
    paid_on: Mapped[str] = mapped_column(String(20), index=True)
    payment_mode: Mapped[str] = mapped_column(String(32), default="cash")
    status: Mapped[str] = mapped_column(String(32), default="paid", index=True)

    loan = relationship("Loan", back_populates="payments")
