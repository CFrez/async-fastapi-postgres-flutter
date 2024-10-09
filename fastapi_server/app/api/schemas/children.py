"""Pydantic domain models for 'children' ressource."""

import datetime as dt
import uuid

from pydantic import ConfigDict

from .base import BaseSchema, IDSchemaMixin

# from.parents import ParentInDB


class ChildBase(BaseSchema):
    """Base schema for 'child'."""

    name: str
    birthdate: dt.date
    hobby: str | None = None
    parent_id: uuid.UUID


class ChildInDB(ChildBase, IDSchemaMixin):
    """Schema for 'child' in database."""

    pass


class ChildCreate(ChildBase):
    """Schema for creating 'child' in database."""

    pass


class ChildUpdate(ChildBase):
    """Schema for updating 'child' in database.

    Updating only allowed for 'name', 'birthdate', 'hobby', 'parent_id' fields.
    All other fields will be ignored.
    """

    model_config = ConfigDict(extra="ignore")

    name: str | None = None
    birthdate: dt.date | None = None
    hobby: str | None = None
    parent_id: uuid.UUID | None = None


class ChildWithParent(ChildInDB):
    # parent: ParentInDB
    pass
