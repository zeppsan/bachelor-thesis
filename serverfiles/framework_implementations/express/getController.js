const fs = require('fs');

exports.getImage = (req, res) => {
    fs.readFile('./img1.png', (err, data) => {
        const imageBuffer = new Buffer.from(data).toString('base64');
        res.status(200).json({
            res: imageBuffer
        })
    });
}

exports.getObject = (req, res) => {
    res.status(200).json({
        Lorem: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra."
    })
}

exports.getSimple = (req, res) => {
    res.status(200).json({
        integer: 1
    })
}

/* Dynamic */
exports.getImageDyn = (req, res) => {
    fs.readFile('./img1.png', (err, data) => {
        const imageBuffer = new Buffer.from(data).toString('base64');
        res.status(200).json({
            res: imageBuffer
        })
    });
}

exports.getObjectDyn = (req, res) => {
    res.status(200).json({
        Id: req.params.id,
        Lorem: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra."  
    })
}

exports.getSimpleDyn = (req, res) => {
    res.status(200).json({
        integer: req.params.id
    })
}