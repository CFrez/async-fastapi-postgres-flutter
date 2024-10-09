"""Endpoints for 'parent' ressource."""

import uuid
from typing import List

from fastapi import APIRouter, Depends, status
from fastapi_filter import FilterDepends

from app.api.dependencies.repository import get_repository
from app.db.repositories.parents import ParentRepository
from app.core.tags_metadata import parents_tag

from ..schemas.parents import ParentCreate, ParentInDB, ParentUpdate, ParentWithChildren

from ..filters.parents import ParentFilter


router = APIRouter(prefix="/parents", tags=[parents_tag.name])


# Basic Parent Endpoints
# =========================================================================== #
@router.post("/", response_model=ParentInDB, status_code=status.HTTP_201_CREATED)
async def create_parent(
    parent_new: ParentCreate,
    parent_repo: ParentRepository = Depends(get_repository(ParentRepository)),
) -> ParentInDB:
    result = await parent_repo.create(obj_new=parent_new)
    return ParentInDB.model_validate(result)


@router.get("/{parent_id}/", response_model=ParentWithChildren)
async def read_parent(
    parent_id: uuid.UUID,
    parent_repo: ParentRepository = Depends(get_repository(ParentRepository)),
) -> ParentWithChildren:
    result = await parent_repo.read_parent_with_children(id=parent_id)
    return ParentWithChildren.model_validate(result)


@router.patch("/{parent_id}/", response_model=ParentInDB)
async def update_parent(
    parent_id: uuid.UUID,
    parent_update: ParentUpdate,
    parent_repo: ParentRepository = Depends(get_repository(ParentRepository)),
) -> ParentInDB:
    result = await parent_repo.update(id=parent_id, obj_update=parent_update)
    return ParentInDB.model_validate(result)


@router.delete("/{parent_id}/", response_model=ParentInDB)
async def delete_parent(
    parent_id: uuid.UUID,
    parent_repo: ParentRepository = Depends(get_repository(ParentRepository)),
) -> ParentInDB:
    result = await parent_repo.delete(id=parent_id)
    return ParentInDB.model_validate(result)


@router.get("/", response_model=List[ParentWithChildren])
async def list_parents(
    parent_filter=FilterDepends(ParentFilter),
    parent_repo: ParentRepository = Depends(get_repository(ParentRepository)),
) -> List[ParentWithChildren]:
    result = await parent_repo.list_parents_with_children(parent_filter)
    return [ParentWithChildren.model_validate(parent) for parent in result]
