/// Copyright (c) 2024 Kodeco Inc.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ArticleView: View {
  let article: Article
  let persistence: Persistence

  @Environment(\.openURL)
  var openURL

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(article.title)
        .font(.headline)
        .padding(.bottom)
        .frame(alignment: .leading)
      imageView
      Text(article.description ?? "")
        .font(.subheadline)
        .foregroundColor(.secondary)
      HStack {
        Text(article.publishedAt?.formatted() ?? "Date not available")
          .font(.caption)
        Spacer()
        Button("", systemImage: "square.and.arrow.up") {
          if let url = URL(string: article.url) {
            openURL(url)
          }
        }
        Button("", systemImage: "square.and.arrow.down") {
          Task { await persistence.saveToDisk(article) }
        }
      }
    }
    .padding(8)
    .buttonStyle(BorderlessButtonStyle())
  }

  @ViewBuilder var imageView: some View {
    if let urlToImage = article.urlToImage {
      AsyncImage(url: URL(string: urlToImage)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .background(.clear)
          .mask(RoundedRectangle(cornerRadius: 8))
      } placeholder: {
        ProgressView()
          .frame(alignment: .center)
      }
      .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

#Preview {
  ArticleView(article: .sample, persistence: Persistence())
}
