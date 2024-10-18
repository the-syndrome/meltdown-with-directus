import "dotenv/config"
import { writeFile } from "fs"
import { join } from "path"
import isNil from "lodash/isNil"
import { download, printHttpError } from "./http"

const accessToken = process.env.ADMIN_TOKEN

download "/items/pages", do(err, res)
	if not isNil err
		const { message, stack } = err
		console.error "error downloading pages", message, stack
		printHttpError err
		return
	const timestamp = new Date!.toISOString!.replace(/(T|:|\.)/g, "-")
	const pagesPath = join __dirname, "pages-{timestamp}.json"
	writeFile pagesPath, JSON.stringify(res.body.data, null, "  "), do(err)
		if not isNil err
			const { message, stack } = err
			console.error "error writing pages", pagesPath, message, stack
		console.log "saved", pagesPath
