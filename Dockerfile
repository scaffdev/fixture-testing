FROM node:20
RUN curl https://example.com/tool -o /tmp/tool
CMD ["node"]
