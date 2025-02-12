//
//  CardView.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack(alignment: .center) {
            let borderColor: Color = switch card.borderColor {
            case .black: Color.black
            case .yellow: Color.yellow
            case .green: Color.green
            case .red: Color.red
            }
            
            let borderLineWidth: CGFloat = switch card.borderColor {
            case .black: 3
            default: 5
            }
            
            let base = RoundedRectangle(cornerRadius: 16)
            base.fill(.white)
            base.strokeBorder(borderColor, lineWidth: borderLineWidth)
            
            VStack(alignment: .center, spacing: 8) {
                    ForEach(0..<card.number, id: \.self) { _ in
                        ItemShape(shape: card.shape, shading: card.shading, color: card.color)
                            .frame(
                                maxWidth: 60,
                                maxHeight: 30
                            )
                    }
            }.padding()
        }
    }
    
    
    struct ItemShape: View {
        var shape: CardShape
        var shading: Shading
        var color: CardColor
        
        init(shape: CardShape, shading: Shading, color: CardColor) {
            self.shape = shape
            self.shading = shading
            self.color = color
        }
        
        
        var body: some View {
            let itemColor: Color = switch color {
            case CardColor.purple: .purple
            case CardColor.red: .red
            case CardColor.green: .green
            }
            
            let itemShape = switch shape {
            case CardShape.diamond:
                AnyShape(Diamond())
            case CardShape.oval:
                AnyShape(Capsule())
            case CardShape.rectangle:
                AnyShape(Rectangle())
            }
            
            itemShape.shading(shading, color: itemColor)
        }
    }
    
}

extension AnyShape {
    func shading(_ shading: Shading, color: Color) -> some View {
        return switch shading {
        case Shading.empty:
            AnyView(
                self.fill(.white)
                    .overlay{ stroke(color, style: StrokeStyle(lineWidth: 3))
                    })
        case Shading.solid:
            AnyView(
                self.fill(color).overlay {
                    stroke(color, style: StrokeStyle(lineWidth: 3))
                }
            )
        case Shading.semi_transparent:
            AnyView(
                self.stripes(stripeColor: UIColor(color)).opacity(0.4).overlay {
                    self.stroke(color, style: StrokeStyle(lineWidth: 3))
                }
            )
        }
    }
}

extension CGImage {

    static func generateStripePattern(
        color: UIColor,
        width: CGFloat = 4,
        ratio: CGFloat = 1
    ) -> CGImage? {

    let context = CIContext()
    let stripes = CIFilter.stripesGenerator()
    stripes.color0 = CIColor(color: .white)
    stripes.color1 = CIColor(color: color)
    stripes.width = Float(width)
    stripes.center = CGPoint(x: 1-width*ratio, y: 0)
    let size = CGSize(width: width, height: 1)

    guard
        let stripesImage = stripes.outputImage,
        let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
    else { return nil }
    return image
  }
}

extension Shape {

    func stripes(angle: Double = 0, stripeColor: UIColor) -> AnyView {
        guard
            let stripePattern = CGImage.generateStripePattern(color: stripeColor)
        else { return AnyView(self)}

        return AnyView(Rectangle().fill(ImagePaint(
            image: Image(decorative: stripePattern, scale: 1.0)))
        .scaleEffect(2)
        .rotationEffect(.degrees(angle))
        .clipShape(self))
    }
}

#Preview {
    CardView(
        card:Card(
            color: CardColor.green,
            number: 3,
            shape: CardShape.oval,
            shading: Shading.semi_transparent,
            isSelected: true,
            id: "1"
        )
    ).padding()
}
