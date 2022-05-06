const fs = require('fs');

exports.postImage = (req, res) => {
    const image = req.body.image.replace(/^data:image\/png;base64,/,"").toString("base64");
    res.status(200).json({
        res: 1
    })
}

exports.postObject = (req, res) => {
    res.status(200).json({
        res: 1
    })
}

exports.postSimple = (req, res) => {
    res.status(200).json({
        res: 1
    })
}


/* Dynamic */

exports.postImageDyn = (req, res) => {
    const image = req.body.image.replace(/^data:image\/png;base64,/,"").toString("base64");
    res.status(200).json({
        res: req.params.id
    })
}

exports.postObjectDyn = (req, res) => {
    res.status(200).json({
        res: req.params.id
    })
}

exports.postSimpleDyn = (req, res) => {
    res.status(200).json({
        res: req.params.id
    })
}