FROM python:3.8

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY ledserver /ledserver

EXPOSE 8080
WORKDIR /ledserver
CMD ["python", "app.py"]
