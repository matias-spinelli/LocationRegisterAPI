# LocationRegisterAPI


docker run -d \
  --name mongo \
  -p 27017:27017 \
  -v mongo_data:/data/db \
  mongo:7
  
  
  
  
  🚀 ¿Cómo levantar todo?

Desde la carpeta del proyecto:

docker compose up -d


✔ Levanta Vapor
✔ Levanta MongoDB
✔ Levanta Mongo Express (UI web)



- primera vez inicializar las sucursales
curl -X POST http://localhost:8080/api/initSucursales



⭐ GET sucursales
curl http://localhost:8080/api/sucursales

⭐ POST sucursal
curl -X POST http://localhost:8080/api/sucursales \
  -H "Content-Type: application/json" \
  -d '{
    "name":"Test",
    "address":"Fake",
    "latitude": -34.0,
    "longitude": -58.0
  }'

⭐ GET registros
curl http://localhost:8080/api/registros

⭐ POST registro
curl -X POST http://localhost:8080/api/registros \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": "2025-12-10T12:00:00Z",
    "tipo": "entrada",
    "sucursalID": "test-sucursal",
    "userID": "test-user"
  }'
