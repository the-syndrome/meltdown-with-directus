import "dotenv/config"
import { writeFile } from "fs"
import { join } from "path"
import isNil from "lodash/isNil"
import series from "async/series"
import urlJoin from "url-join"
import { post, printHttpError, alreadyExists } from "./http"
import schemaSnapshot from "./schema.json"

const accessToken = process.env.ADMIN_TOKEN

const steps = []

for collection in schemaSnapshot.collections
	steps.push do(done)
		const { collection: colName } = collection
		post "/collections", collection, do(err)
			if not isNil err
				const { message, stack } = err
				if alreadyExists err
					console.log "collection exists", colName
					return done!
				console.error "error posting collection", colName, message, stack
				printHttpError err
				return done err
			console.log "created collection", colName
			done!

for field in schemaSnapshot.fields.filter(do $1.field isnt "id")
	steps.push do(done)
		const { collection: colName, field: fieldName, type } = field
		post urlJoin("/fields", colName), field, do(err)
			if not isNil err
				const { message, stack } = err
				if alreadyExists err
					console.log "field exists", colName, fieldName, type
					return done!
				console.error "error posting field", colName, message, stack
				printHttpError err
				return done err
			console.log "created field", colName, fieldName, type
			done!

series steps, do(err)
	if not isNil err
		const { message, stack } = err
		console.error "error applying schema snapshot", message, stack
		return
	console.log "schema applied"
