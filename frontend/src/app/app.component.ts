import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { Product } from './product';

import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-root',
  imports: [CommonModule, HttpClientModule],

  standalone: true,  // 👈 Esto activa modo standalone
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'frontend';
  products: Product[] = [];

  constructor(private http: HttpClient) {
    this.http.get<Product[]>('http://localhost:8080/products')
      .subscribe(data => this.products = data);
  }

  showDetails(product: any) {
    alert(`Producto: ${product.name}\nPrecio: $${product.price}`);
  }
  
}
