"""Abstract CRUD Repo definitions."""

from abc import ABC
from typing import List, TypeVar

from fastapi import HTTPException, status
from loguru import logger
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.base import BaseModel
from app.api.schemas.base import BaseSchema
from app.api.filters.base import BaseFilter

## ===== Custom Type Hints ===== ##
# sqlalchemy models
SQLA_MODEL = TypeVar("SQLA_MODEL", bound=BaseModel)

# pydantic models
CREATE_SCHEMA = TypeVar("CREATE_SCHEMA", bound=BaseSchema)
UPDATE_SCHEMA = TypeVar("UPDATE_SCHEMA", bound=BaseSchema)
FILTER_SCHEMA = TypeVar("FILTER_SCHEMA", bound=BaseFilter)
RESPONSE_SCHEMA = TypeVar("UPDATE_SCHEMA", bound=BaseSchema)


## ===== CRUDL Repo ===== ##
class SQLAlchemyRepository(ABC):
    """Abstract SQLAlchemy repo defining basic database operations.

    Basic CRUDL methods used by domain models to interact with the
    database are defined here.
    """

    def __init__(
        self,
        db: AsyncSession,
    ) -> None:
        self.db = db

    label: str = "entity"
    capitalized_label: str = label.capitalize()

    # models and schemas object instanziation and validation
    sqla_model = SQLA_MODEL

    create_schema = CREATE_SCHEMA
    update_schema = UPDATE_SCHEMA
    filter_schema = FILTER_SCHEMA
    response_schema = RESPONSE_SCHEMA

    def not_found_error(
        self, id: int, action: str, entity: str = label
    ) -> HTTPException:
        """Raise 404 error for missing object."""
        logger.warning(f"No {entity} with id = {id}.")
        return HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Unable to {action}, no {entity} found with id = {id}.",
        )

    ## ===== Basic crudl Operations ===== ##
    async def create(self, obj_new: create_schema) -> response_schema | None:
        """Commit new object to the database."""
        try:
            db_obj_new = self.sqla_model(**obj_new.dict())
            self.db.add(db_obj_new)

            await self.db.commit()
            await self.db.refresh(db_obj_new)

            logger.success(f"Created new {self.label}: {db_obj_new}.")

            return self.response_schema.model_validate(db_obj_new)

        except Exception as e:

            await self.db.rollback()

            logger.exception(f"Error while creating new {self.label} to database")
            logger.exception(e)

            return None

    async def read(
        self,
        id: int,
    ) -> response_schema | None:
        """Get object by id or 404."""
        result = await self.db.get(self.sqla_model, id)

        if not result:
            raise self.not_found_error(id, "read")

        return self.response_schema.model_validate(result)

    async def update(
        self,
        id: int,
        obj_update: update_schema,
    ) -> response_schema | None:
        """Update object in db by id or 404."""
        result = await self.db.get(self.sqla_model, id)

        if not result:
            raise self.not_found_error(id, "update")

        for key, value in obj_update.dict(exclude_unset=True).items():
            setattr(result, key, value)

        await self.db.commit()
        await self.db.refresh(result)

        logger.success(f"Updated {self.label}: {result}.")

        return self.response_schema.model_validate(result)

    async def delete(
        self,
        id: int,
    ) -> response_schema | None:
        """Delete object from db by id or 404."""
        result = await self.db.get(self.sqla_model, id)

        if not result:
            raise self.not_found_error(id, "delete")

        await self.db.delete(result)
        await self.db.commit()

        # TODO: check if result in string broke once converting to f-string
        logger.success(
            f"{self.capitalized_label}: {result} successfully deleted from database."
        )

        return self.response_schema.model_validate(result)

    async def filter_list(
        self,
        list_filter: filter_schema,
    ) -> List[response_schema] | None:
        """Get all filtered and sorted objects from the database."""
        query = select(self.sqla_model)
        query = list_filter.filter(query)
        query = list_filter.sort(query)
        result = await self.db.execute(query)
        result = result.scalars().all()
        return [self.response_schema.model_validate(obj) for obj in result]

    def create_routes(self, router):
        """Create CRUDL routes for the repository."""
        router.post("/", response_model=self.response_schema, status_code=status.HTTP_201_CREATED)(
            self.create
        )
        router.get("/{id}", response_model=self.response_schema)(self.read)
        router.patch("/{id}", response_model=self.response_schema)(self.update)
        router.delete("/{id}", response_model=self.response_schema)(self.delete)
        router.get("/", response_model=List[self.response_schema])(self.filter_list)
