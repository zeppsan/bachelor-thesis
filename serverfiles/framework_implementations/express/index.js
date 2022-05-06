const getController = require('./getController')
const postController = require('./postController')
const express = require('express')
const app = express()
app.use(express.json())

/* Regular get */
app.get('/get/image', getController.getImage)
app.get('/get/object', getController.getObject)
app.get('/get/simple', getController.getSimple)

/* Dynamic get */
app.get('/get/image/:id', getController.getImageDyn)
app.get('/get/object/:id', getController.getObjectDyn)
app.get('/get/simple/:id', getController.getSimpleDyn)


/**
 * #################
 * #
 * # POST Routes
 * #
 * ################
 */

app.post('/post/image', postController.postImage)
app.post('/post/object', postController.postObject)
app.post('/post/simple', postController.postSimple)

/* Dynamic */
app.post('/post/image/:id', postController.postImageDyn)
app.post('/post/object/:id', postController.postObjectDyn)
app.post('/post/simple/:id', postController.postSimpleDyn)


app.listen(8000)