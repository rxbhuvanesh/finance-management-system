from pydantic import BaseModel


class CustomerBase(BaseModel):
    name: str
    mobile_number: str
    address: str
    aadhaar_number: str
    notes: str | None = None


class CustomerCreate(CustomerBase):
    pass


class CustomerUpdate(CustomerBase):
    pass


class CustomerOut(CustomerBase):
    id: int

    class Config:
        from_attributes = True
