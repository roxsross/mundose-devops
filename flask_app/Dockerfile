FROM public.ecr.aws/docker/library/python:alpine3.19
RUN pip install flask
COPY app.py ./app.py
CMD ["python", "app.py"]