# 古典目标识别

#### 混淆矩阵

通俗理解FP就是误检，FN就是漏检。

#### resize 和 reshap的区别

resize就是改变大小，reshape就是改变了形状

#### selective search的思想

就是层级聚类，进行融合，是根据颜色、条纹等的相似度进行合并。ss给出的就是候选框。比如说给出1000-2000个候选框。
#### R-CNN的一开始的正例和负样本是怎样确定的？

首先是使用SS方法对区域进行融合，计算每一个候选区域与真实区域GT之间的重合度，如果重合度在20-50%之间的话，而且与其它的任何一个已生成的负样本之间的重合度不大于70%，则为负样本。当然这个负样本的Iou的重合度的阈值是可以自己进行调整的，比如说想让与样本多一点，就调小一下IOU。
		正样本就是我们手工标记的那些GT。

#### R-CNN

R就是region，cnn就是一个卷积神经网络，这里是做特征的提取的。就是通过ss获取到候选区域之后，然后对一系列的不同尺寸的候选区域进行resize；然后经过svm进行分类，然后还有一个回归器，用来调整回归框。这里的svm是有多个的，每一个只用来做二分类使用。
		为什么要resize成一样的尺寸？因为后面使用到的是同一个分类器和回归器（这个是线性回归），所以必须是统一的尺寸。

缺点：
		（1）通过selective search进行候选框的提取，这个是写死的，没有办法进行相应的学习。计算速度很慢。
		（2）需要进行resize。
		（3）候选框可能会有重复的可能性，会有重复的计算。
		（4）总体上还是很慢，很多的IO。
#### SPP NEt
	原来这个是解决上面的那个resize的问题。还有解决了一个 重复计算的问题，就是映射的问题。 
	spp net中会有多个池化核。池化核的大小和池化的窗口有什么不同呢？
	这个图中选取了三个池化核。
	池化之后，然后进行conc，就可以得到一样的特征数目。 
	原图进行conv之后，没有改变特征图的大小。？？？
#### R-CNN的特征提取网络是怎样的？

#### 关于池化层的特殊理解
	池化层不改变通道数。所以池化是对通道的每一层进行操作的。
#### fast R-CNN
	使用的池化叫做ROI polling。而R-CNN中使用的是叫做SPP NET. ROI pooling 是SPPNET的一个简化版本而已。
	ROI pooling之后，接一个全连接，然后分两个分支，一个是Linear + softmax，另个一个是进行Linear进行矫正。
	关于最后的分类器和回归器的作用的问题：都是对于SS获取之后的候选区进行处理。训练的结果是使分类器更好的识别，回归的结果是使回归器更好地矫正，就是对于给出的ss候选区的矫正。
	分类器的输出，是给定的类别+1，这里的1是背景类。
	有一个具体的过程就是，比如ss给出了2000个候选框，然后就是，这2000个候选框都是给到分类器去进行分类，得到的是分类的loss。但是回归器是对非背景类的进行矫正，对于背景类的话，是没有必要进行矫正的。所以呢，根据total_loss = Log loss + smooth_L1 loss这个公式，明显算回归的loss会比较少，所以需要给定一个权重给到回归，相乘大一点，这样的话就认为回归和分类时一样重要的。

#### faster R-CNN