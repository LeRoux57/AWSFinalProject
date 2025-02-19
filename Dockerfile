FROM python:3.9

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_APP run.py
ENV DEBUG False

COPY requirements.txt .

# install python dependencies
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

COPY env.sample .env

COPY . .

# Init migration folder
RUN flask db init 
RUN flask db migrate 
RUN flask db upgrade

# gunicorn
CMD ["gunicorn", "--config", "gunicorn-cfg.py", "run:app"]
