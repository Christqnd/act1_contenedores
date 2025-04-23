package org.acme;

import java.util.List;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/products")
@Produces(MediaType.APPLICATION_JSON)
public class ProductResource {

    @Inject
    EntityManager em;

    @GET
    public List<Product> getAll() {
        return em.createQuery("FROM Product", Product.class).getResultList();
    }
}
