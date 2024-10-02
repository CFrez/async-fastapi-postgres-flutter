"""Base classes for fastai filters.

Provides base filters for what is in the BaseSchema.
"""

import uuid
from datetime import datetime

from fastapi_filter.contrib.sqlalchemy import Filter

from app.db.models.base import BaseModel


class BaseFilter(Filter):
    id: uuid.UUID | None = None
    id__in: list[uuid.UUID] | None = None
    # These could be extended to include `_at`, `_at__lt`, `_at__gt for more
    # complex filtering, but this is sufficient for a demo set.
    created_at__gte: datetime | None = None
    created_at__lte: datetime | None = None
    updated_at__gte: datetime | None = None
    updated_at__lte: datetime | None = None

    # Default ordering by updated_at with most recent first
    order_by: list[str] = ["-updated_at"]

    class Constants(Filter.Constants):
        model = BaseModel
