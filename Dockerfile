FROM node:current-alpine as base
WORKDIR /app
COPY package.json ./
#RUN yarn install --frozen-lockfile
RUN npm install
COPY . .



# Linux + Node + Source + Project dependencies + build assets
FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /app ./
#RUN yarn run build
RUN npm run build



# We keep some artifacts from build
FROM node:current-alpine AS production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package*.json ./
COPY --from=build /build/.next ./.next
#COPY --from=build /build/public ./public
RUN npm install next
#RUN yarn add next
EXPOSE 3000
CMD npm run start
#ENTRYPOINT [ "yarn", "start"]
