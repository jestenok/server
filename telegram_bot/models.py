from sqlalchemy import Column, Integer, String, DateTime, Boolean, sql
from database import Base


class User(Base):
    __tablename__ = 'users'

    user_id = Column(Integer, primary_key=True)
    username = Column(String(32))
    first_name = Column(String(256))
    last_name = Column(String(256))
    language_code = Column(String(8))
    deep_link = Column(String(64))

    is_blocked_bot = Column(Boolean)
    is_banned = Column(Boolean)

    is_admin = Column(Boolean)
    is_moderator = Column(Boolean)

    created_at = Column(DateTime, server_default=sql.func.now())
    updated_at = Column(DateTime, server_default=sql.func.now())

    waiting_for_input = Column(Boolean)
    waiting_for_announcement = Column(Boolean)

    photo_id = Column(String(255))

    def __init__(self, user_id=None, username=None):
        self.user_id = user_id
        self.username = username

    def __repr__(self):
        return "".format(self.code)
