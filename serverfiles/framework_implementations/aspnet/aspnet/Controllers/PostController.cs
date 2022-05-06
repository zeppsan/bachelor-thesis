using System;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc;

namespace aspnet.Controllers
{

    public class ImageBody
    {
        [BindProperty]
        public string Image { get; set; }
    }
    
    public class ObjectBody
    {
        [BindProperty]
        public string Lorum { get; set; }
    }

    public class PostController : ControllerBase
    {
        [HttpPost]
        [Route("post/image")]
        public IActionResult PostImage([FromBody] ImageBody imageBody)
        {
            var x = Convert.FromBase64CharArray(imageBody.Image.ToCharArray(), 0, imageBody.Image.Length);
            return new JsonResult(new {res=1});
        }
        
        [HttpPost]
        [Route("post/simple")]
        [Route("post/object")]
        public IActionResult PostObject([FromBody] ObjectBody objectBody)
        {
            return new JsonResult(new {res=1});
        }
        
        /* Dynamic */
        
        [HttpPost]
        [Route("post/image/{id}")]
        public IActionResult PostImageDyn([FromBody] ImageBody imageBody, int id)
        {
            var x = Convert.FromBase64CharArray(imageBody.Image.ToCharArray(), 0, imageBody.Image.Length);
            return new JsonResult(new {res=id});
        }
        
        [HttpPost]
        [Route("post/simple/{id}")]
        [Route("post/object/{id}")]
        public IActionResult PostObjectDyn([FromBody] ObjectBody objectBody, int id)
        {
            return new JsonResult(new {res=id});
        }
    }
}