const options = {
  definition: {
    openapi: "3.1.0",
    info: {
      title: "PVD Things API",
      version: "1.0.0",
      description:
        "A bridge between Airtable, Supabase, and the PVD Things suite of applications.",
      license: {
        name: "GNU General Public License v3.0",
        url: "https://www.gnu.org/licenses/gpl-3.0.en.html",
      },
    },
    servers: [],
  },
  apis: ["./docs/**/*.yaml"],
};

const buildOptions = ({ port }) => {
  let builtOptions = options;
  builtOptions.servers = [{ url: `http://localhost/${port}` }];

  return builtOptions;
};

module.exports = buildOptions;