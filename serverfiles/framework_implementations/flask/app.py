from flask import Flask, request
import base64
import os

app = Flask(__name__)

@app.route('/get/image/<val>', methods=['GET'])
def get_imageDynamically(val):
    # imgID = "images/img" + str(val) + ".png"
    imgID = "images/img1.png"
    with open(imgID , 'rb') as image:
        image_read = image.read()
        b = base64.b64encode(image_read)
        s = b.decode()
    return {"Id": val, "res": s }

@app.route('/get/object/<val>', methods=['GET'])
def get_obectDynamically(val):
    return {"Id": val,
            "Lorem": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra."}

@app.route('/get/simple/<val>', methods=['GET'])
def get_simpleDynamically(val):
    return { "integer" : val }

@app.route('/get/image', methods=['GET'])
def get_image():
    with open('images/img1.png', 'rb') as image:
        image_read = image.read()
        b = base64.b64encode(image_read)
        s = b.decode() 
    return {"res": s}

@app.route('/get/object', methods=['GET'])
def get_object():
    return {"Lorem": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra."}

@app.route('/get/simple', methods=['GET'])
def get_simple():
    return { "integer" : 1 }



####################POST########################


@app.route('/post/image/<val>', methods=['POST'])
def post_imageDynamically(val):
    a = bytes(request.json['image'],'UTF-8')
    b = base64.decodebytes(a)
    # path = "images/img" + str(val) + ".png"
    # with open(path, "wb") as f:
    #     f.write(b)
    # os.remove(path)
    return { "res" : val }

@app.route('/post/object/<val>', methods=['POST'])
def post_obectDynamically(val):
    req = request.json
    return { "res" : val }

@app.route('/post/simple/<val>', methods=['POST'])
def post_simpleDynamically(val):
    req = request.json
    return { "res" : val }

@app.route('/post/image', methods=['POST'])
def post_image():
    a = bytes(request.json['image'],'UTF-8')
    b = base64.decodebytes(a)
    # with open("images/img2.png", "wb") as f:
    #     f.write(b)
    return { "res" : 1 }

#Returns the same json that gets passed in
@app.route('/post/object', methods=['POST'])
def post_object():
    req = request.json
    return { "res": 1 }

@app.route('/post/simple', methods=['POST'])
def post_simple():
    req = request.json
    return { "res" : 1 }


if __name__ == '__main__':
    app.use(host="0.0.0.0", port=8080)