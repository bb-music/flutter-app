const fs = require('fs');

const binaryFileToBase64 = (filePath) => {
  const binaryData = fs.readFileSync(filePath);
  return Buffer.from(binaryData).toString('base64');
};

const filePath = './bbmusic-keystore.jks';
const base64String = binaryFileToBase64(filePath);
console.log(base64String);
