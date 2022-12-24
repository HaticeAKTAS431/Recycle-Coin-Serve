const soap = require("soap");

class NVI {
  constructor() {}

  static async TCIdentityInquiryAsync({
    identityNo,
    firstName,
    lastName,
    birthYear,
  }) {
    return new Promise((resolve, reject) => {
      soap.createClient(process.env.NVI_ENDPOINT, function (err, client) {
        if (err) reject(err);
        client.TCKimlikNoDogrula(
          {
            TCKimlikNo: identityNo,
            Ad: firstName.toLocaleUpperCase("tr"),
            Soyad: lastName.toLocaleUpperCase("tr"),
            DogumYili: birthYear,
          },
          function (err, result) {
            if (err) reject(err);
            resolve(result.TCKimlikNoDogrulaResult);
          }
        );
      });
    });
  }
}

module.exports = NVI;
