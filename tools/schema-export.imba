import "dotenv/config"
import { writeFile } from "fs"
import { join } from "path"
import isNil from "lodash/isNil"
import { download } from "./http"

const accessToken = process.env.ADMIN_TOKEN

download "/schema/snapshot", do(err, res)
	if not isNil err
		const { message, stack } = err
		console.error "error downloading snapshot", message, stack
		return
	const timestamp = new Date!.toISOString!.replace(/(T|:|\.)/g, "-")
	const schemaPath = join __dirname, "schema-{timestamp}.json"
	writeFile schemaPath, JSON.stringify(res.body.data, null, "  "), do(err)
		if not isNil err
			const { message, stack } = err
			console.error "error writing snapshot", schemaPath, message, stack
		console.log "saved", schemaPath
