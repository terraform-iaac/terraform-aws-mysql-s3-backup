FROM public.ecr.aws/lambda/python:2.7

RUN yum update && yum install -y mysql
RUN yum clean all

COPY lambda_function.py /var/task/app.py

CMD [ "app.handler" ]