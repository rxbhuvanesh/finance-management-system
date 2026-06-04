from pydantic import BaseModel


class LoanCreate(BaseModel):
    customer_id: int
    principal_amount: float
    interest_percentage: float
    emi_duration_months: int
    due_day: int


class PaymentCreate(BaseModel):
    loan_id: int
    amount: float
    paid_on: str
    payment_mode: str = "cash"


class LoanOut(BaseModel):
    id: int
    customer_id: int
    principal_amount: float
    interest_percentage: float
    emi_duration_months: int
    due_day: int
    status: str

    class Config:
        from_attributes = True


class PaymentOut(BaseModel):
    id: int
    loan_id: int
    amount: float
    paid_on: str
    payment_mode: str
    status: str

    class Config:
        from_attributes = True
