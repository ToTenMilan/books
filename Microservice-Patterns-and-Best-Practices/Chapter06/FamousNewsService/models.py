import os
from datetime import datetime
from mongoengine import (
    connect,
    Document,
    DateTimeField,
    ListField,
    IntField,
    StringField,
)

from sqlalchemy import (
    Column,
    String,
    BigInteger,
    DateTime,
    Index,
)
from sqlalchemy.dialects import postgresql
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()


# Base (Postgres) to write data
class CommandNewsModel(Base):
    __tablename__ = 'news'

    id = Column(BigInteger, primary_key=True)
    # version of updated article instance.
    # Here "updating" means not really updating the instance of model
    # but creating the new with higher version.
    # This way we preserve the history of updates
    # and prepare the app for "Event Sourcing"
    version = Column(BigInteger, primary_key=True)
    title = Column(String(length=200))
    content = Column(String)
    author = Column(String(length=50))
    created_at = Column(DateTime, default=datetime.utcnow)
    published_at = Column(DateTime)
    news_type = Column(String, default='famous')
    tags = Column(postgresql.ARRAY(String))

    __table_args__ = Index('index', 'id', 'version'),


connect('famous', host=os.environ.get('QUERYBD_HOST'))


# MongoDB to read data
class QueryNewsModel(Document):
    id = IntField(primary_key=True)
    version = IntField(required=True)
    title = StringField(required=True, max_length=200)
    content = StringField(required=True)
    author = StringField(required=True, max_length=50)
    created_at = DateTimeField(default=datetime.utcnow)
    published_at = DateTimeField()
    news_type = StringField(default="famous")
    tags = ListField(StringField(max_length=50))
