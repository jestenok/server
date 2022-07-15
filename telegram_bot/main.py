from database import init_db, db_session
from models import User


init_db()

u = User(2423234, 'jestenok')
db_session.add(u)
db_session.commit()

db_session.remove()

