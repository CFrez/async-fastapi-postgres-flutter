"""Pydantic domain models for 'parents' ressource."""

import datetime as dt

from pydantic import ConfigDict

from .base import BaseSchema, IDSchemaMixin
from .children import ChildInDB


class ParentBase(BaseSchema):
    """Base schema for 'parent'."""

    name: str
    birthdate: dt.date


class ParentInDB(ParentBase, IDSchemaMixin):
    """Schema for 'parent' in database."""

    pass


class ParentCreate(ParentBase):
    """Schema for creating 'parent' in database."""

    pass


class ParentUpdate(ParentBase):
    """Schema for updating 'parent' in database.

    Updating only allowed for 'name', 'birthdate' fields.
    All other fields will be ignored.
    """

    model_config = ConfigDict(extra="ignore")

    name: str | None = ...
    birthdate: dt.date | None = ...


class ParentWithChildren(ParentInDB):
    """Schema for 'parent' with children."""

    # children_ids: list[int] = []
    children: list[ChildInDB] = []
    pass
