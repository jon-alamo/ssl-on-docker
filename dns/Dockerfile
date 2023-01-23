FROM python:alpine

# Install dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
COPY update_dns.py /app/update_dns.py

COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

WORKDIR /app
CMD ["./run.sh"]
