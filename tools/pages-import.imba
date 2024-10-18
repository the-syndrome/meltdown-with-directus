import "dotenv/config"
import { writeFile } from "fs"
import { join } from "path"
import isNil from "lodash/isNil"
import series from "async/series"
import { post, printHttpError, alreadyExists } from "./http"
import pagesExport from "./pages.json"

const accessToken = process.env.ADMIN_TOKEN

post "/items/pages", pagesExport, do(err)
	if not isNil err
		if alreadyExists err
			console.log "pages already imported"
			return
		const { message, stack } = err
		console.error "error importing pages", message, stack
		printHttpError err
		return
	console.log "pages imported", pagesExport.length
