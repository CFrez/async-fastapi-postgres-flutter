"""Domain Repository for 'parent' entity.

All logic related to the parent entity is defined and grouped here.
"""

from typing import List

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.api.filters.parents import ParentFilter
from app.api.schemas.parents import ParentCreate, ParentUpdate
from app.db.models.parents import Parent as ParentModel
from app.db.repositories.base import SQLAlchemyRepository


class ParentRepository(SQLAlchemyRepository):
    """Handle all logic related to Parent entity.

    Inheritence from 'SQLAlchemyRepository' allows for crudl functionality.
    """

    label = "parent"

    sqla_model = ParentModel

    create_schema = ParentCreate
    update_schema = ParentUpdate
    filter_schema = ParentFilter

    async def list_parents_with_children(
        self,
        list_filter: filter_schema,
    ) -> List[sqla_model] | None:
        """Get all parents with their children."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.children))
        query = list_filter.filter(query)
        query = list_filter.sort(query)
        results = await self.db.execute(query)
        return results.scalars().all()

    async def read_parent_with_children(
        self,
        id,
    ) -> sqla_model | None:
        """Get parent with their children by id."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.children))
        result = await self.db.execute(query)
        if not result:
            raise self.not_found_error(id, "read")
        return result.scalars().first()
