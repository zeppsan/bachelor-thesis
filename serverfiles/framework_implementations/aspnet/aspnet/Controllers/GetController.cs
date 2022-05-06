using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json.Serialization;
using Microsoft.Extensions.Logging;

namespace aspnet.Controllers
{
    [ApiController]
    public class GetController : ControllerBase
    {
        [HttpGet]
        [Route("get/image")]
        public IActionResult GetImage()
        {
            var image = Convert.ToBase64String(System.IO.File.ReadAllBytes("../images/img1.png"));
            return new JsonResult(new
            {
                image=image
            });
        }
        
        [HttpGet]
        [Route("get/object")]
        public IActionResult GetObject()
        {
            return new JsonResult(new
            {
                Lorem="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra.",
            });
        }
        
        [HttpGet]
        [Route("get/simple")]
        public IActionResult GetSimple()
        {
            return new JsonResult(new
            {
                integer=1
            });
        }
        
        /* Dynamic */
        
        [HttpGet]
        [Route("get/image/{id}")]
        public IActionResult GetImageDyn(int id)
        {
            var image = Convert.ToBase64String(System.IO.File.ReadAllBytes("../images/img1.png"));
            return new JsonResult(new
            {
                image=image
            });
        }
        
        [HttpGet]
        [Route("get/object/{id}")]
        public IActionResult GetObjectDyn(int id)
        {
            return new JsonResult(new
            {
                Id=id,
                Lorem="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris hendrerit cursus diam, ut ornare nibh elementum vitae. Curabitur non mattis dui. Aenean at risus mattis, venenatis enim vel, blandit nulla. Vestibulum ultricies purus in vestibulum mollis. Sed et sagittis nisl. Aenean nec viverra tortor. Integer pellentesque condimentum nibh at vestibulum. Ut nisl est, posuere nec eleifend non, elementum ullamcorper mauris. Nullam quis sem vel nibh faucibus auctor. Etiam consequat arcu ut suscipit efficitur. Phasellus sodales leo vitae tortor pretium lacinia. Duis congue felis vitae mauris consequat pharetra. Sed venenatis justo vel condimentum aliquam. Sed rutrum porttitor tellus placerat tincidunt. Cras tempus auctor ornare. Donec ornare justo sit amet hendrerit aliquet. Sed in aliquet quam. Maecenas luctus ipsum nec risus eleifend, id tempus ante malesuada. Cras viverra.",
            });
        }
        
        [HttpGet]
        [Route("get/simple/{id}")]
        public IActionResult GetSimpleDyn(int id)
        {
            return new JsonResult(new
            {
                integer=id
            });
        }
    }
}