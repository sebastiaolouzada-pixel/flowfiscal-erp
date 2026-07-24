from fastapi import APIRouter, HTTPException
from typing import List
from pydantic import BaseModel
from datetime import datetime
from decimal import Decimal

router = APIRouter()


class InvoiceItemCreate(BaseModel):
    """Invoice item creation schema"""
    description: str
    quantity: float
    unit_price: Decimal


class InvoiceCreate(BaseModel):
    """Invoice creation schema"""
    customer_name: str
    invoice_number: str
    items: List[InvoiceItemCreate]
    status: str = "draft"


class InvoiceResponse(BaseModel):
    """Invoice response schema"""
    id: int
    customer_name: str
    invoice_number: str
    status: str
    created_at: datetime
    total_amount: Decimal

    class Config:
        from_attributes = True


# Mock data for demonstration
invoices_db = [
    {
        "id": 1,
        "customer_name": "Client A",
        "invoice_number": "INV-001",
        "status": "paid",
        "created_at": datetime.now(),
        "items": [
            {"description": "Service 1", "quantity": 1, "unit_price": Decimal("100.00")},
        ],
        "total_amount": Decimal("100.00"),
    },
]


@router.get("", response_model=List[InvoiceResponse])
async def list_invoices():
    """List all invoices"""
    return invoices_db


@router.get("/{invoice_id}", response_model=InvoiceResponse)
async def get_invoice(invoice_id: int):
    """Get a specific invoice by ID"""
    invoice = next((i for i in invoices_db if i["id"] == invoice_id), None)
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice


@router.post("", response_model=InvoiceResponse)
async def create_invoice(invoice: InvoiceCreate):
    """Create a new invoice"""
    # Calculate total amount
    total_amount = sum(
        Decimal(str(item.quantity)) * item.unit_price
        for item in invoice.items
    )
    
    new_invoice = {
        "id": len(invoices_db) + 1,
        "customer_name": invoice.customer_name,
        "invoice_number": invoice.invoice_number,
        "status": invoice.status,
        "created_at": datetime.now(),
        "items": [item.dict() for item in invoice.items],
        "total_amount": total_amount,
    }
    invoices_db.append(new_invoice)
    return new_invoice


@router.put("/{invoice_id}", response_model=InvoiceResponse)
async def update_invoice(invoice_id: int, invoice: InvoiceCreate):
    """Update an invoice"""
    existing_invoice = next((i for i in invoices_db if i["id"] == invoice_id), None)
    if not existing_invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    
    # Calculate new total
    total_amount = sum(
        Decimal(str(item.quantity)) * item.unit_price
        for item in invoice.items
    )
    
    existing_invoice.update({
        "customer_name": invoice.customer_name,
        "invoice_number": invoice.invoice_number,
        "status": invoice.status,
        "items": [item.dict() for item in invoice.items],
        "total_amount": total_amount,
    })
    
    return existing_invoice


@router.delete("/{invoice_id}")
async def delete_invoice(invoice_id: int):
    """Delete an invoice"""
    invoice = next((i for i in invoices_db if i["id"] == invoice_id), None)
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    
    invoices_db.remove(invoice)
    return {"message": "Invoice deleted successfully"}
