FROM public.ecr.aws/docker/library/node:alpine

WORKDIR /usr/src/app

COPY package.json .
RUN npm install --loglevel warn
COPY index.js index.html ./

ENV PORT=8080
CMD [ "node", "." ]

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.4.1 /lambda-adapter /opt/extensions/lambda-adapter
