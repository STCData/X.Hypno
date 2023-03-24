function JSCanvasDebug() {
// create a canvas element that covers the whole window
const canvas = document.createElement('canvas');
canvas.id = 'my-canvas';
canvas.width = document.documentElement.clientWidth;
canvas.height = document.documentElement.clientHeight;
canvas.style.position = 'fixed';
canvas.style.top = '0';
canvas.style.left = '0';
canvas.style.pointerEvents = 'none';
document.body.appendChild(canvas);

// get the canvas context
const ctx = canvas.getContext('2d');


// save the current state of the canvas
ctx.save();

//// translate the canvas to the center
//ctx.translate(canvas.width/2, canvas.height/2);
//
//// flip the canvas upside down
//ctx.scale(1, -1);
//
//// mirror the canvas horizontally
////ctx.scale(-1, 1);
//
//// translate the canvas back to its original position
//ctx.translate(-canvas.width/2, -canvas.height/2);

// draw the magenta border
ctx.lineWidth = 1;
ctx.strokeStyle = 'rgba(255, 0, 255, 0.1)';
ctx.strokeRect(1.5, 1.5, canvas.width - 3, canvas.height - 3);

// draw the X shape
ctx.beginPath();
ctx.moveTo(0, 0);
ctx.lineTo(canvas.width, canvas.height);
ctx.moveTo(canvas.width, 0);
ctx.lineTo(0, canvas.height);
ctx.lineWidth = 17;
ctx.strokeStyle = 'rgba(255, 0, 255, 0.03)';
ctx.stroke();


  const label = `JS IS LOADED!`;
  const centerX = canvas.width / 2;
  const bottomY = canvas.height - 40;
  ctx.font = 'bold 40px Arial';
  ctx.textAlign = 'center';
  ctx.fillStyle = '#ffffff06';
  ctx.clearRect(0, bottomY - 45, canvas.width, 25);
  ctx.fillText(label, centerX, bottomY);


var element = document.getElementById("jsNotLoaded");
element.remove();


return {
 "width": canvas.width,
 "height": canvas.height
}

}

JSCanvasDebug()
