from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.middleware.auth import get_current_user
from app.schemas.customer import CustomerCreate, CustomerOut, CustomerUpdate
from app.services.finance_service import create_customer, delete_customer, list_customers, update_customer

router = APIRouter(prefix="/customers", tags=["customers"], dependencies=[Depends(get_current_user)])


@router.get("", response_model=list[CustomerOut])
async def get_customers(search: str | None = Query(default=None), db: AsyncSession = Depends(get_db)):
    return await list_customers(db, search)


@router.post("", response_model=CustomerOut)
async def add_customer(payload: CustomerCreate, db: AsyncSession = Depends(get_db)):
    return await create_customer(db, payload)


@router.put("/{customer_id}", response_model=CustomerOut)
async def edit_customer(customer_id: int, payload: CustomerUpdate, db: AsyncSession = Depends(get_db)):
    updated = await update_customer(db, customer_id, payload)
    if not updated:
        raise HTTPException(status_code=404, detail="Customer not found")
    return updated


@router.delete("/{customer_id}")
async def remove_customer(customer_id: int, db: AsyncSession = Depends(get_db)):
    ok = await delete_customer(db, customer_id)
    if not ok:
        raise HTTPException(status_code=404, detail="Customer not found")
    return {"success": True}
