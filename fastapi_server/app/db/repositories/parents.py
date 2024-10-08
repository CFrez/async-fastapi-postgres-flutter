"""Domain Repository for 'parent' entity.

All logic related to the parent entity is defined and grouped here.
"""

from typing import List

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.db.models.parents import Parent as ParentModel

# from app.db.models.children import Child as ChildModel
from app.db.repositories.base import SQLAlchemyRepository
from app.api.schemas.parents import ParentCreate, ParentUpdate
from app.api.filters.parents import ParentFilter


class ParentRepository(SQLAlchemyRepository):
    """Handle all logic related to Parent entity.

    Inheritence from 'SQLAlchemyRepository' allows for
    crudl functionality, only schemata and models used have to be defined.
    """

    label = "parent"

    sqla_model = ParentModel

    create_schema = ParentCreate
    update_schema = ParentUpdate
    filter_schema = ParentFilter

    # async def get_children_by_parent_id(
    #     self,
    #     id,
    # ) -> List[sqla_model] | None:
    #     """Get all children belonging to a certain parent."""
    #     stmt = select(self.sqla_model).options(selectinload(self.sqla_model.children)).filter_by(id=id)

    #     res = await self.db.execute(stmt)

    #     parent =  res.scalars().first()
    #     if parent is None:
    #         return None
    #     else:
    #         return parent.children

    async def get_parents_with_children(
        self,
        list_filter: filter_schema,
    ) -> List[sqla_model] | None:
        """Get all parents with their children."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.children))
        query = list_filter.filter(query)
        query = list_filter.sort(query)
        results = await self.db.execute(query)
        return results.scalars().all()
